Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaKZJoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:44:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaKZJoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:44:20 -0500
Message-ID: <5475A0F0.6060402@suse.com>
Date: Wed, 26 Nov 2014 10:44:16 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: frequent lockups in 3.18rc4
References: <20141114213124.GB3344@redhat.com>	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>	<20141115213405.GA31971@redhat.com>	<20141116014006.GA5016@redhat.com>	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>	<20141126002501.GA11752@redhat.com>	<CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>	<5475596A.9010301@suse.com>	<CA+55aFx1SiFBzmA=k9jHxi3cZE3Ei_+2NHepujgf86KEvkz8eQ@mail.gmail.com>	<54756424.6020409@suse.com>	<CA+55aFzVyTi_pR4y3=Z3y1bWkXbvgoJaykoyn0pUE7eTYgr+ZQ@mail.gmail.com> <CA+55aFzOSfdvgrkfiN=zZg4mSoot-tJQiVRh5ENW2-rzmLMy1w@mail.gmail.com>
In-Reply-To: <CA+55aFzOSfdvgrkfiN=zZg4mSoot-tJQiVRh5ENW2-rzmLMy1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 07:21 AM, Linus Torvalds wrote:
> On Tue, Nov 25, 2014 at 9:52 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> And leave it running for a while, and see if the trace is always the
>> same, or if there are variations on it...
>
> Amusing.
>
> Lookie here:
>
>     http://lists.xenproject.org/archives/html/xen-changelog/2005-08/msg00310.html
>
> That's from 2005.
>
> Anyway, I don't see why the cr3 issue matters, *unless* there is some
> situation where the scheduler can run with interrupts enabled. And why
> this is Xen-related, I have no idea.
>
> The Xen patches seem to have lost that
>
>   /* On Xen the line below does not always work. Needs investigating! */
>
> line when backporting the 2.6.29 patches to Xen. And clearly nobody
> investigated.
>
> So please do get me back-traces, and we'll investigate. Better late
> than never. But it does sound Xen-specific - although it's possible
> that Xen just triggers some timing (and has apparently been able to
> trigger it since 2005) that DaveJ now triggers on his one machine.
>
> So DaveJ, even though this does appear Xen-centric (Xentric?) and
> you're running on bare hardware, maybe you could do the same thing in
> that x86-64 vmalloc_fault(). The timing with Jürgen is kind of
> intriguing - if 3.18-rc made it happen much more often for him, maybe
> it really is very timing-sensitive, and you actually are seeing a
> non-Xen version of the same thing...

Very interesting: I've updated my test-machine yesterday to the newest
Xen version after I've got rid of the lockups to avoid another problem
I was seeing. With this version I don't get the lockups any more even
with the unmodified 3.18-rc kernel.

Digging deeper I found something making me believe I've seen another
issue than Dave which just looked similar on the surface. :-(

My Xen problem was related to an error in freeing grant pages (pages
mapped in from another domain). One detail in the handling of such
mappings is interesting: the "private" member of the page structure
is used to hold the machine frame number of the mapped memory page.
Another usage of this "private" member is in the pgd handling of Xen
(see xen_pgd_alloc() and xen_get_user_pgd()) to hold the pgd of the
user address space (kernel and user are in separate address spaces on
Xen). So with an error in the grant page handling I could imagine a
pgd's private member could be clobbered leading to effects like the one
I've observed. And this could have been the problem in 2005, too.

And why is my patch working? I think it's just because cr3 is always
written with a page aligned value while the clobbered "private" member
of the Xen pgd is not page aligned resulting in a different pointer.
I'm still using the wrong page for the user's pgd, but this seems not
to lead to fatal errors when nearly nothing is running on the machine.
I've seen Xen messages occasionally indicating there was something
wrong with the page table handling of the kernel (pages used as page
tables not known to Xen as such).

I hope this all makes sense.

And just for the records: with the actual Xen version (tweaked to
show the grant page error again) I see different lockups with the
following backtrace:

[ 1122.256305] NMI watchdog: BUG: soft lockup - CPU#94 stuck for 23s! 
[systemd-udevd:1179]
[ 1122.303427] Modules linked in: xen_blkfront msr bridge stp llc 
iscsi_ibft ipmi_devintf nls_utf8 x86_pkg_temp_thermal intel_powerclamp 
nls_cp437 coretemp crct10dif_pclmul vfat crc32_pclmul fat crc32c_intel 
ghash_clmulni_intel snd_pcm aesni_intel aes_x86_64 snd_timer lrw 
be2iscsi be2net gf128mul libiscsi snd glue_helper joydev vxlan soundcore 
scsi_transport_iscsi ablk_helper iTCO_wdt ixgbe igb mdio ip6_udp_tunnel 
iTCO_vendor_support efivars evdev iscsi_boot_sysfs udp_tunnel cryptd dca 
pcspkr sb_edac e1000e edac_core lpc_ich i2c_i801 ptp mfd_core pps_core 
shpchp tpm_infineon ipmi_si tpm_tis ipmi_msghandler tpm button xenfs 
xen_privcmd xen_acpi_processor processor thermal_sys xen_pciback 
xen_netback xen_blkback xen_gntalloc xen_gntdev xen_evtchn dm_mod 
efivarfs crc32c_generic btrfs xor raid6_pq hid_generic
[ 1122.303450]  usbhid hid sd_mod mgag200 ehci_pci i2c_algo_bit ehci_hcd 
drm_kms_helper ttm usbcore drm megaraid_sas usb_common sg scsi_mod autofs4
[ 1122.303456] CPU: 94 PID: 1179 Comm: systemd-udevd Tainted: G 
     L 3.18.0-rc5+ #304
[ 1122.303458] Hardware name: FUJITSU PRIMEQUEST 2800E/SB, BIOS 
PRIMEQUEST 2000 Series BIOS Version 01.59 07/24/2014
[ 1122.303459] task: ffff881f17b56ce0 ti: ffff881f0fff0000 task.ti: 
ffff881f0fff0000
[ 1122.303460] RIP: e030:[<ffffffff814fcf5e>]  [<ffffffff814fcf5e>] 
_raw_spin_lock+0x1e/0x30
[ 1122.303462] RSP: e02b:ffff881f0fff3ce8  EFLAGS: 00000282
[ 1122.303463] RAX: 000000000000ba43 RBX: 00003ffffffff000 RCX: 
0000000000000190
[ 1122.303464] RDX: 0000000000000190 RSI: 000000190ba43067 RDI: 
ffffea000157c350
[ 1122.303465] RBP: ffff880000000c70 R08: 0000000000000000 R09: 
0000000000000000
[ 1122.303466] R10: 000000000001b688 R11: ffff881fdf24ad80 R12: 
ffffea0000000000
[ 1122.303466] R13: ffff88006237cc70 R14: 0000000000000000 R15: 
00007f70f438e000
[ 1122.303470] FS:  00007f70f5c49880(0000) GS:ffff881f4c5c0000(0000) 
knlGS:ffff881f4c5c0000
[ 1122.303471] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1122.303472] CR2: 00007f70f5c68000 CR3: 0000001f111b7000 CR4: 
0000000000042660
[ 1122.303473] Stack:
[ 1122.303474]  ffffffff81155850 ffff881fdf24ad80 00007f70f438f000 
ffff881f138ae5d8
[ 1122.303476]  ffff881f08ead400 ffff881f0fff3fd8 0000000000000000 
ffff881eff0cbd08
[ 1122.303477]  ffff881f18b57d08 ffffea000157c320 ffffea006ccc5ec8 
ffff881f0fc00800
[ 1122.303479] Call Trace:
[ 1122.303481]  [<ffffffff81155850>] ? copy_page_range+0x460/0xa10
[ 1122.303484]  [<ffffffff8105d727>] ? copy_process.part.27+0x13e7/0x1b10
[ 1122.303486]  [<ffffffff81435f41>] ? netlink_insert+0x91/0xb0
[ 1122.303488]  [<ffffffff813f85c9>] ? release_sock+0x19/0x160
[ 1122.303490]  [<ffffffff8105dff8>] ? do_fork+0xc8/0x320
[ 1122.303492]  [<ffffffff814fd779>] ? stub_clone+0x69/0x90
[ 1122.303493]  [<ffffffff814fd42d>] ? system_call_fastpath+0x16/0x1b
[ 1122.303494] Code: 90 0f b7 17 66 39 d0 75 f6 eb e8 66 90 b8 00 00 01 
00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 89 d1 75 01 c3 0f b7 07 66 39 d0 
74 f7 <f3> 90 0f b7 07 66 39 c8 75 f6 c3 0f 1f 80 00 00 00 00 65 81 04

But if my assumptions above are correct this is meaningless, as using
an arbitrary memory page as pgd might result in anything...


Juergen
