Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaHIAPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:15:52 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:49237 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaHIAPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:15:51 -0400
MIME-Version: 1.0
In-Reply-To: <53E53DCD.2020707@linaro.org>
References: <CALAqxLWAXU0hS8si-CmkOObBOHGv_skMVfPnUsdmLcZzkdUsWA@mail.gmail.com>
	<53E53DCD.2020707@linaro.org>
Date: Fri, 8 Aug 2014 17:15:50 -0700
X-Google-Sender-Auth: eBOpBc0A1-CAlDWztgQikeLTF0o
Message-ID: <CAGXu5j+Q8F8TKy8sxCL6pxD-cni4RKxy46HwsCSZE+mWpuyn-g@mail.gmail.com>
Subject: Re: [Regression] 3.15 mmc related ext4 corruption with qemu-system-arm
From: Kees Cook <keescook@chromium.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Johan Rudholm <jrudholm@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 2:14 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 06/11/2014 10:35 PM, John Stultz wrote:
>> I've been seeing some ext4 corruption with recent kernels under qemu-system-arm.
>>
>> This issue seems to crop up after shutting down uncleanly (terminating
>> qemu), shortly after booting about 50% of the time.
>>
>> ext4/mmc related dmesg details are:
>> [    3.206809] mmci-pl18x mb:mmci: mmc0: PL181 manf 41 rev0 at
>> 0x10005000 irq 41,42 (pio)
>> [    3.268316] mmc0: new SDHC card at address 4567
>> [    3.281963] mmcblk0: mmc0:4567 QEMU! 2.00 GiB
>> [    3.315699]  mmcblk0: p1 p2 p3 p4 < p5 p6 >
>> ...
>> [   11.806169] EXT4-fs (mmcblk0p5): Ignoring removed nomblk_io_submit option
>> [   11.904714] EXT4-fs (mmcblk0p5): recovery complete
>> [   11.905854] EXT4-fs (mmcblk0p5): mounted filesystem with ordered
>> data mode. Opts: nomblk_io_submit,errors=panic
>> ...
>> [   91.558824] EXT4-fs error (device mmcblk0p5):
>> ext4_mb_generate_buddy:756: group 1, 2252 clusters in bitmap, 2284 in
>> gd; block bitmap corrupt.
>> [   91.560641] Aborting journal on device mmcblk0p5-8.
>> [   91.562589] Kernel panic - not syncing: EXT4-fs (device mmcblk0p5):
>> panic forced after error
>> [   91.562589]
>> [   91.563486] CPU: 0 PID: 1 Comm: init Not tainted 3.15.0-rc1 #560
>> [   91.564616] [<c00116e5>] (unwind_backtrace) from [<c000f3b1>]
>> (show_stack+0x11/0x14)
>> [   91.565154] [<c000f3b1>] (show_stack) from [<c04262b1>]
>> (dump_stack+0x59/0x7c)
>> [   91.565666] [<c04262b1>] (dump_stack) from [<c0423297>] (panic+0x67/0x178)
>> [   91.566147] [<c0423297>] (panic) from [<c0134bb1>]
>> (ext4_handle_error+0x69/0x74)
>> [   91.566659] [<c0134bb1>] (ext4_handle_error) from [<c0135437>]
>> (__ext4_grp_locked_error+0x6b/0x160)
>> [   91.567223] [<c0135437>] (__ext4_grp_locked_error) from
>> [<c0143079>] (ext4_mb_generate_buddy+0x1b1/0x29c)
>> [   91.567860] [<c0143079>] (ext4_mb_generate_buddy) from [<c01447e5>]
>> (ext4_mb_init_cache+0x219/0x4e0)
>> [   91.568473] [<c01447e5>] (ext4_mb_init_cache) from [<c0144b67>]
>> (ext4_mb_init_group+0xbb/0x138)
>> [   91.569021] [<c0144b67>] (ext4_mb_init_group) from [<c0144cd7>]
>> (ext4_mb_good_group+0xf3/0xfc)
>> [   91.569659] [<c0144cd7>] (ext4_mb_good_group) from [<c0145c8f>]
>> (ext4_mb_regular_allocator+0x153/0x2c4)
>> [   91.570250] [<c0145c8f>] (ext4_mb_regular_allocator) from
>> [<c0148095>] (ext4_mb_new_blocks+0x2fd/0x4e4)
>> [   91.570868] [<c0148095>] (ext4_mb_new_blocks) from [<c013f931>]
>> (ext4_ext_map_blocks+0x965/0x10bc)
>> [   91.571444] [<c013f931>] (ext4_ext_map_blocks) from [<c0122c8b>]
>> (ext4_map_blocks+0xfb/0x36c)
>> [   91.571992] [<c0122c8b>] (ext4_map_blocks) from [<c01263b1>]
>> (mpage_map_and_submit_extent+0x99/0x5f0)
>> [   91.572614] [<c01263b1>] (mpage_map_and_submit_extent) from
>> [<c0126bc1>] (ext4_writepages+0x2b9/0x4e8)
>> [   91.573201] [<c0126bc1>] (ext4_writepages) from [<c0094ae9>]
>> (do_writepages+0x19/0x28)
>> [   91.573709] [<c0094ae9>] (do_writepages) from [<c008c811>]
>> (__filemap_fdatawrite_range+0x3d/0x44)
>> [   91.574265] [<c008c811>] (__filemap_fdatawrite_range) from
>> [<c008c883>] (filemap_flush+0x23/0x28)
>> [   91.574854] [<c008c883>] (filemap_flush) from [<c012bf75>]
>> (ext4_rename+0x2f9/0x3e4)
>> [   91.575360] [<c012bf75>] (ext4_rename) from [<c00c3363>]
>> (vfs_rename+0x183/0x45c)
>> [   91.575911] [<c00c3363>] (vfs_rename) from [<c00c3867>]
>> (SyS_renameat2+0x22b/0x26c)
>> [   91.576460] [<c00c3867>] (SyS_renameat2) from [<c00c38df>]
>> (SyS_rename+0x1f/0x24)
>> [   91.576961] [<c00c38df>] (SyS_rename) from [<c000cd01>]
>> (ret_fast_syscall+0x1/0x5c)
>>
>>
>> Bisecting this points to: e7f3d22289e4307b3071cc18b1d8ecc6598c0be4
>> (mmc: mmci: Handle CMD irq before DATA irq). Which I guess shouldn't
>> be surprising, as I saw problems with that patch earlier in the
>> 3.15-rc cycle:
>>     https://lkml.org/lkml/2014/4/14/824
>>
>> However that discussion petered out (possibly my fault for not
>> following up) as to if it was an issue with the patch or a issue with
>> qemu.  Then the original issue disappeared for me, which I figured was
>> due to a fix upstream, but now I'm guessing coincided with me updating
>> my system and getting qemu v2.0 (where as previously I was on 1.5).
>>
>> $ qemu-system-arm -version
>> QEMU emulator version 2.0.0 (Debian 2.0.0+dfsg-2ubuntu1.1), Copyright
>> (c) 2003-2008 Fabrice Bellard
>>
>> While the previous behavior was annoying and kept my emulated
>> environments from booting, this while a bit more rare and subtle eats
>> the disks, which is much more painful for my testing.
>>
>> Unfortunately reverting the change (manually, as it doesn't revert
>> cleanly anymore) doesn't seem to completely avoid the issue, so the
>> bisection may have gone slightly astray (though it is interesting it
>> landed on the same commit I earlier had trouble with). So I'll
>> back-track and double check some of the last few "good" results to
>> validate I didn't just luck into 3 good boots accidentally. I'll also
>> review my revert in case I missed something subtle in doing it
>> manually.
>>
>> Anyway, if there is any thoughts on how to better chase this down and
>> debug it, I'd appreciate it! I can also provide reproduction
>> instructions with a pre-built Linaro android disk image and hand built
>> kernel if anyone wants to debug this themselves.
>
> So I just wanted to check if anyone else tried looking into this issue?
> I'd be happy to share my qemu environment, config, etc.
>
> I sunk a couple of weeks bisecting to try to narrow down the more
> sporadic issue, but was unsuccessful past the initial commit above.
> Since then I've been far too swamped to spend any more time on it. Even
> so, its a *major* pain for testing but it seems like no one else really
> cares?

I'm in the same boat as far as poor bisection results. :(

However, I keep using the 3-patch mmci fix series from Ulf, and
haven't hit any trouble with them. Though perhaps I'm just getting
lucky?

http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=arm/fix-mmci

-Kees

-- 
Kees Cook
Chrome OS Security
