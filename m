Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab3EJG44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 02:56:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab3EJG4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 02:56:54 -0400
Date: Fri, 10 May 2013 08:56:44 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, dzickus@redhat.com,
        kernel-team@fedoraproject.org, Heinz Diehl <htd@fritha.org>
Subject: Re: NULL pointer dereference in xhci_free_dev
Message-ID: <20130510065644.GA3320@dhcp-26-164.brq.redhat.com>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <20130507140333.GB3380@dhcp-26-164.brq.redhat.com>
 <20130509221559.GD10305@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509221559.GD10305@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 03:15:59PM -0700, Sarah Sharp wrote:
> On Tue, May 07, 2013 at 04:03:33PM +0200, Frantisek Hrbata wrote:
> > Hi,
> 
> Hi Frantisek,
> 
> > there is a NULL pointer dereference in xhci_free_dev if
> > xhci_alloc_dev timeouts while waiting for a slot. Fedora has several bugs
> > reporting this problem.
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=957500
> > https://bugzilla.redhat.com/show_bug.cgi?id=959016
> > https://bugzilla.redhat.com/show_bug.cgi?id=921659
> > https://bugzilla.redhat.com/show_bug.cgi?id=892935
> > 
> > I also found one mention about this on lkml without any reply
> 
> Thanks for bringing this to my attention.  I don't subscribe to lkml, so
> these types of bugs slip by me unless someone Ccs the linux-usb mailing
> list or me.

Thank you for your quick response.

> 
> Can you reproduce the bug yourself on 3.9, or should I work with Heinz
> to have him test a fix?

I haven't tried to reproduce. I was asked to help with Fedora's bugs triage and
these come up. The goal was just to contact the right people and bring this to
their attention. If you have a patch for this, I guess we can try to ask Heinz,
or other people reporting this problem, to help with testing.

Heinz: Sorry I forgot to add you to CC in the first mail, but Sarah fixed it.

Thank you

> 
> Sarah Sharp
> 
> > Date: Fri, 14 Dec 2012 22:54:28 +0100
> > From: Heinz Diehl <htd@fritha.org>
> > To: linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org
> > Subject: [3.6.10] Null pointer dereference (xhci)
> > Message-ID: <20121214215428.GA4465@fancy-poultry.org>
> > https://lkml.org/lkml/2012/12/14/369
> > 
> > This was first seen on 3.6.7 and it is also reported for 3.9.0. IMHO the current
> > kernel has the same problem.
> > 
> > Here follows more info for one of the oops. It's for x86, but other reports are
> > for x86_64.
> > 
> > vanilla kernel 3.9.0 drivers/usb/host/xhci.c
> > 
> >   3110	void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
> >   3111	{
> >   3112		struct xhci_hcd *xhci = hcd_to_xhci(hcd);
> >   3113		struct xhci_virt_device *virt_dev;
> >   3114		unsigned long flags;
> >   3115		u32 state;
> >   3116		int i, ret;
> >        
> >   3117		ret = xhci_check_args(hcd, udev, NULL, 0, true, __func__);
> >   3118		/* If the host is halted due to driver unload, we still need to free the
> >   3119		 * device.
> >   3120		 */
> >   3121		if (ret <= 0 && ret != -ENODEV)
> >   3122			return;
> >        
> >   3123		virt_dev = xhci->devs[udev->slot_id];
> >        
> >   3124		/* Stop any wayward timer functions (which may grab the lock) */
> >   3125		for (i = 0; i < 31; ++i) {
> >   3126			virt_dev->eps[i].ep_state &= ~EP_HALT_PENDING;
> >   3127			del_timer_sync(&virt_dev->eps[i].stop_cmd_timer);
> >   3128		}
> >  
> > The problem is that virt_dev could be NULL(line 3123) and we get NULL deref.
> > while accessing endpoints(line 3126). 
> > 
> > Linux version 3.9.0-0.rc8.git0.2.fc19.i686.PAE
> > BUG: unable to handle kernel NULL pointer dereference at 00000024
> > IP: [<c0806e90>] xhci_free_dev+0x60/0x130
> > *pdpt = 0000000000000000 *pde = f000eef3f000eef3 
> > Oops: 0002 [#1] SMP 
> > Modules linked in: ebtable_nat ipt_MASQUERADE nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack bnep bluetooth rfkill ebtable_filter ebtables ip6table_filter ip6_tables iTCO_wdt iTCO_vendor_support ppdev snd_ice1724 snd_ak4113 snd_pt2258 snd_ak4114 mperf snd_i2c snd_ice17xx_ak4xxx coretemp snd_ak4xxx_adda crc32_pclmul snd_rawmidi crc32c_intel snd_ac97_codec ac97_bus serio_raw microcode i2c_i801 snd_seq snd_seq_device lpc_ich snd_pcm mfd_core snd_page_alloc snd_timer snd soundcore atl1c mei parport_pc parport vhost_net tun macvtap macvlan kvm_intel binfmt_misc kvm usb_storage i915 i2c_algo_bit drm_kms_helper drm i2c_core video uinput
> > Pid: 34, comm: khubd Not tainted 3.9.0-0.rc8.git0.2.fc19.i686.PAE #1 To Be Filled By O.E.M. To Be Filled By O.E.M./H61M/U3S3
> > EIP: 0060:[<c0806e90>] EFLAGS: 00010246 CPU: 0
> > EIP is at xhci_free_dev+0x60/0x130
> > EAX: 00000000 EBX: 0000001f ECX: f12f7000 EDX: 00000000
> > ESI: ec2f4000 EDI: 0000003c EBP: f1323ec8 ESP: f1323ea8
> >  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > CR0: 80050033 CR2: 00000024 CR3: 00d0f000 CR4: 000407f0
> > DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > DR6: ffff0ff0 DR7: 00000400
> > Process khubd (pid: 34, ti=f1322000 task=f122d940 task.ti=f1322000)
> > Stack:
> >  00000000 00000001 c09f83d8 f09f4e00 f12f7000 ec2f4000 ffffff00 f0aec034
> >  f1323f6c c07d97b4 00000001 c0b7f660 00000004 c0c00540 f1323f64 c09911c6
> >  f75ba2c0 f1323efc f122d940 f0aec0a0 00000064 f122d940 f0aafe1c f09f4e00
> > Call Trace:
> >  [<c07d97b4>] hub_thread+0x704/0x1520
> >  [<c09911c6>] ? __schedule+0x366/0x780
> >  [<c046ccf0>] ? wake_up_bit+0x20/0x20
> >  [<c07d90b0>] ? hub_port_debounce+0x140/0x140
> >  [<c046c2b4>] kthread+0x94/0xa0
> >  [<c0999d77>] ret_from_kernel_thread+0x1b/0x28
> >  [<c046c220>] ? insert_kthread_work+0x30/0x30
> > Code: e8 16 ba ff ff 83 f8 ed 0f 85 bd 00 00 00 8b 86 a8 02 00 00 bb 1f 00 00 00 8b 55 f0 8b 94 82 a4 00 00 00 8d 7a 3c 90 8d 74 26 00 <83> 67 e8 fb 89 f8 81 c7 8c 00 00 00 e8 bf 4f c5 ff 83 eb 01 75
> > EIP: [<c0806e90>] xhci_free_dev+0x60/0x130 SS:ESP 0068:f1323ea8
> > CR2: 0000000000000024
> > 
> > 
> > Code: e8 16 ba ff ff 83 f8 ed 0f 85 bd 00 00 00 8b 86 a8 02 00 00 bb 1f 00 00 00 8b 55 f0 8b 94 82 a4 00 00 00 8d 7a 3c 90 8d 74 26 00 <83> 67 e8 fb 89 f8 81 c7 8c 00 00 00 e8 bf 4f c5 ff 83 eb 01 75
> > All code
> > ========
> >    0:	e8 16 ba ff ff       	call   0xffffba1b
> >    5:	83 f8 ed             	cmp    $0xffffffed,%eax
> >    8:	0f 85 bd 00 00 00    	jne    0xcb
> >    e:	8b 86 a8 02 00 00    	mov    0x2a8(%esi),%eax
> >   14:	bb 1f 00 00 00       	mov    $0x1f,%ebx
> >   19:	8b 55 f0             	mov    -0x10(%ebp),%edx
> >   1c:	8b 94 82 a4 00 00 00 	mov    0xa4(%edx,%eax,4),%edx
> >   23:	8d 7a 3c             	lea    0x3c(%edx),%edi
> >   26:	90                   	nop
> >   27:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
> >   2b:*	83 67 e8 fb          	andl   $0xfffffffb,-0x18(%edi)     <-- trapping instruction
> >   2f:	89 f8                	mov    %edi,%eax
> >   31:	81 c7 8c 00 00 00    	add    $0x8c,%edi
> >   37:	e8 bf 4f c5 ff       	call   0xffc54ffb
> >   3c:	83 eb 01             	sub    $0x1,%ebx
> >   3f:	75                   	.byte 0x75
> > 
> > Code starting with the faulting instruction
> > ===========================================
> >    0:	83 67 e8 fb          	andl   $0xfffffffb,-0x18(%edi)
> >    4:	89 f8                	mov    %edi,%eax
> >    6:	81 c7 8c 00 00 00    	add    $0x8c,%edi
> >    c:	e8 bf 4f c5 ff       	call   0xffc54fd0
> >   11:	83 eb 01             	sub    $0x1,%ebx
> >   14:	75                   	.byte 0x75
> > 
> > 
> > http://download.eng.brq.redhat.com/pub/fedora/linux//development/19/i386/debug/k/kernel-PAE-debuginfo-3.9.0-0.rc8.git0.2.fc19.i686.rpm
> > 
> > $ objdump -t vmlinux | grep xhci_free_dev
> > c08064d0 g     F .text	0000003d xhci_free_device_endpoint_resources
> > c0806e30 g     F .text	00000128 xhci_free_dev
> > 
> > $ objdump -d --start-address=0xc0806e30 --stop-address=0xc0806f60 vmlinux
> > 
> > vmlinux:     file format elf32-i386
> > 
> > 
> > Disassembly of section .text:
> > 
> > c0806e30 <xhci_free_dev>:
> > c0806e30:	55                   	push   %ebp
> > c0806e31:	89 e5                	mov    %esp,%ebp
> > c0806e33:	57                   	push   %edi
> > c0806e34:	56                   	push   %esi
> > c0806e35:	53                   	push   %ebx
> > c0806e36:	83 ec 14             	sub    $0x14,%esp
> > c0806e39:	e8 d6 35 19 00       	call   c099a414 <mcount>
> > c0806e3e:	8b 88 08 01 00 00    	mov    0x108(%eax),%ecx
> > 
> > ecx = xhci
> > 
> > c0806e44:	c7 44 24 08 d8 83 9f 	movl   $0xc09f83d8,0x8(%esp)
> > c0806e4b:	c0 
> > c0806e4c:	89 d6                	mov    %edx,%esi
> > c0806e4e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
> > c0806e51:	31 c9                	xor    %ecx,%ecx
> > c0806e53:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
> > c0806e5a:	00 
> > c0806e5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
> > c0806e62:	89 45 ec             	mov    %eax,-0x14(%ebp)
> > c0806e65:	e8 16 ba ff ff       	call   c0802880 <xhci_check_args>
> > c0806e6a:	83 f8 ed             	cmp    $0xffffffed,%eax
> > c0806e6d:	0f 85 bd 00 00 00    	jne    c0806f30 <xhci_free_dev+0x100>
> > c0806e73:	8b 86 a8 02 00 00    	mov    0x2a8(%esi),%eax
> > c0806e79:	bb 1f 00 00 00       	mov    $0x1f,%ebx
> > 
> > initialize i for the loop 0 to 31
> > i = 0x1f
> > 
> > c0806e7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
> > 
> > edx = xhci
> > 
> > c0806e81:	8b 94 82 a4 00 00 00 	mov    0xa4(%edx,%eax,4),%edx
> > 
> > edx = virt_dev(struct xhci_virt_device)
> > 
> > c0806e88:	8d 7a 3c             	lea    0x3c(%edx),%edi
> > 
> > 0x3c if offset to xhci_virt_device.eps[0].stop_cmd_timer
> > edi = virt_dev->eps[0].stop_cmd_timer  
> > 
> > c0806e8b:	90                   	nop
> > c0806e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
> > c0806e90:	83 67 e8 fb          	andl   $0xfffffffb,-0x18(%edi)
> > 
> > -0x18 is offset from stop_cmd_timer to ep_state in xhci_virt_ep
> > 
> > c0806e94:	89 f8                	mov    %edi,%eax
> > c0806e96:	81 c7 8c 00 00 00    	add    $0x8c,%edi
> > 
> > edi = next stop_cmd_timer in the esp array(0x8c should be sizeof xhci_virt_ep)
> > 
> > c0806e9c:	e8 bf 4f c5 ff       	call   c045be60 <del_timer_sync>
> > c0806ea1:	83 eb 01             	sub    $0x1,%ebx
> > 
> > i--
> > 
> > c0806ea4:	75 ea                	jne    c0806e90 <xhci_free_dev+0x60>
> > 
> > !i loop
> > 
> > <rest of disasm snipped because it's not important for this problem>
> > 
> > EBX: 0000001f means first iteration(i = 0)
> > EDI: 0000003c this should be address of xhci_virt_device.eps[0].stop_cmd_timer meaning
> >               that the virt_dev is NULL(lea    0x3c(%edx),%edi)
> > 
> > NULL pointer dereference at 00000024 == 0x3c - 0x18 (stop_cmd_timer - ep_state)
> > 
> > So the bottom line is that
> > 
> > virt_dev = xhci->devs[udev->slot_id] is NULL
> > 
> > and the trap is on
> > 
> > virt_dev->eps[i].ep_state &= ~EP_HALT_PENDING;
> > 
> > <log>
> > [   34.489095] usb 3-2.4: new high-speed USB device number 7 using xhci_hcd
> > [   39.398980] xhci_hcd 0000:05:00.0: Timeout while waiting for address device command
> > [   41.823024] usb 3-2.4: Device not responding to set address.
> > [   42.020549] usb 3-2.4: device not accepting address 7, error -71
> > [   46.663202] xhci_hcd 0000:05:00.0: Timeout while waiting for a slot
> > [   63.038765] xhci_hcd 0000:05:00.0: Stopped the command ring failed, maybe the host is dead
> > [   63.038783] xhci_hcd 0000:05:00.0: Abort command ring failed
> > [   63.039033] xhci_hcd 0000:05:00.0: HC died; cleaning up
> > [   63.040009] [sched_delayed] sched: RT throttling activated
> > [   63.045558] hub 3-2:1.0: cannot reset port 4 (err = -19)
> > [   63.045567] hub 3-2:1.0: cannot disable port 4 (err = -19)
> > [   63.045592] BUG: unable to handle kernel NULL pointer dereference at 00000024
> > </log>
> > 
> > xhci_alloc_dev => xhci_cancel_cmd => usb_hc_died => usb_kick_khubd
> > 
> > Based on the messages it looks like xhci_alloc_dev timeouted while waiting
> > for a slot, meaning no xhci_alloc_virt_device call and no eps array
> > initialization. Now hub_events calls hub_port_reset and hub_port_disable
> > reporting
> > [   63.045558] hub 3-2:1.0: cannot reset port 4 (err = -19)
> > [   63.045567] hub 3-2:1.0: cannot disable port 4 (err = -19)
> > and setting USB_STATE_NOTATTACHED which later triggers
> > hub_quiesce => ... => xhci_free_dev and we got the NULL pointer dereference.
> > 
> > Please note that I know practically nothing about usb/xhci, so I for sure could
> > overlooked something. That's also a reason I'm not sending a patch, because
> > I'm not sure if simple virt_dev != NULL in xhci_free_dev is enough/correct to
> > fix this.
> > 
> > Thank you
> > 
> > -- 
> > Frantisek Hrbata

-- 
Frantisek Hrbata
