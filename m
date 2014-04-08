Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbaDHVDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 17:03:44 -0400
Received: from www.sr71.net ([198.145.64.142]:40195 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbaDHVDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 17:03:40 -0400
Message-ID: <5344642A.2020703@sr71.net>
Date: Tue, 08 Apr 2014 14:03:38 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        jslaby@suse.cz
Subject: Re: post 3.14 serial regression
References: <5343416F.8010201@sr71.net> <20140408122726.227f3da8@alan.etchedpixels.co.uk>
In-Reply-To: <20140408122726.227f3da8@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 04:27 AM, One Thousand Gnomes wrote:
>> At the end, you can see that init is somehow dying.  If I revert this
>> patch, init is happy again and doesn't die, and the serial console works
>> like before.
> 
> Can you check if init is getting a SIGHUP - possibly its opening the
> device and when it goes away gets a hangup which it isn't catching ?

I do see plenty of SIGCHLDs and a heap of SIGTERMs to 'systemd-udevd',
but no SIGHUP.  I do see a "Warning: unable to open an initial console."
now, though.  (details far below)

I instrumented uart_remove_one_port().  It *looks* like while searching
for a uart_port for 0x1008 (my actual port),
serial8250_find_match_or_unused() finds 0x3e8 since 0x3e8 is
PORT_UNKNOWN.  The new code unregisters the 0x1008 console since it
_thinks_ it is about to re-register it.

> [   18.280937] uart_remove_one_port() uport: ffffffff828c8020 uart_console(uport): 1 iobase: 3e8 membase:           (null)
> [   18.291970] CPU: 12 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc4+ #301
> [   18.298681] Hardware name: FUJITSU-SV PRIMEQUEST 1800E2/SB, BIOS PRIMEQUEST 1000 Series BIOS Version 1.24 09/14/2011
> [   18.309438]  ffffffff828c8020 ffff881ff2c2b9f8 ffffffff816ca8b5 0000000000000006
> [   18.316941]  ffff88fff1698730 ffff881ff2c2ba28 ffffffff813c759b ffffffff828c8020
> [   18.324452]  00000000ffffffe4 ffff881ff2c2ba88 ffffffff81cddf20 ffff881ff2c2ba58
> [   18.331962] Call Trace:
> [   18.334447]  [<ffffffff816ca8b5>] dump_stack+0x4e/0x68
> [   18.339665]  [<ffffffff813c759b>] uart_remove_one_port+0x12b/0x1b0
> [   18.345935]  [<ffffffff813cb2af>] serial8250_register_8250_port+0xbf/0x3c0
> [   18.352915]  [<ffffffff813ce105>] pciserial_init_ports+0x105/0x200
> [   18.359184]  [<ffffffff813ce2c9>] pciserial_init_one+0xc9/0x1e0
> [   18.365198]  [<ffffffff8135cd1d>] local_pci_probe+0x2d/0x80
> [   18.370849]  [<ffffffff8135d549>] pci_device_probe+0xe9/0x130
> [   18.376686]  [<ffffffff813df4e9>] driver_probe_device+0x89/0x390
> [   18.382778]  [<ffffffff813df89b>] __driver_attach+0xab/0xb0
> [   18.388434]  [<ffffffff813df7f0>] ? driver_probe_device+0x390/0x390
> [   18.394795]  [<ffffffff813dd57e>] bus_for_each_dev+0x5e/0x90
> [   18.400539]  [<ffffffff813df1ee>] driver_attach+0x1e/0x20
> [   18.406016]  [<ffffffff813ddfc7>] bus_add_driver+0x127/0x250
> [   18.411764]  [<ffffffff81d63bda>] ? early_serial_setup+0x138/0x138
> [   18.418032]  [<ffffffff813dfcf4>] driver_register+0x64/0xf0
> [   18.423687]  [<ffffffff81d63bda>] ? early_serial_setup+0x138/0x138
> [   18.429963]  [<ffffffff8135d2c4>] __pci_register_driver+0x64/0x70
> [   18.436146]  [<ffffffff81d62f1b>] ? sysrq_always_enabled_setup+0x20/0x20
> [   18.442954]  [<ffffffff81d63bf3>] serial_pci_driver_init+0x19/0x1b
> [   18.449227]  [<ffffffff81d25f7e>] do_one_initcall+0x9e/0x133
> [   18.454967]  [<ffffffff81d26119>] kernel_init_freeable+0x106/0x19a
> [   18.461241]  [<ffffffff81d258af>] ? do_early_param+0x86/0x86
> [   18.466989]  [<ffffffff816bc090>] ? rest_init+0xe0/0xe0
> [   18.472285]  [<ffffffff816bc09e>] kernel_init+0xe/0xf0
> [   18.477503]  [<ffffffff816d58fc>] ret_from_fork+0x7c/0xb0
> [   18.482978]  [<ffffffff816bc090>] ? rest_init+0xe0/0xe0
> [   18.488277] console [ttyS2] disabled

The last, desperate attempt in serial8250_find_match_or_unused() appears
to incorrectly hone in on my early printk port.  But, even if I comment
it out, I still can't boot.  The only way that work is to revert that patch.

> [   74.281757] TCP: cubic registered
> [   74.284954] NET: Registered protocol family 17
> [   74.301226] registered taskstats version 1
> [   74.311464] console [netcon0] enabled
> [   74.315018] netconsole: network logging started
> [   74.319612] /home/davehans/linux.git/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> [   74.429357] Warning: unable to open an initial console.
> [   74.455233] Freeing unused kernel memory: 1200K (ffffffff81d10000 - ffffffff81e3c000)
> [   74.463028] Write protecting the kernel read-only data: 12288k
> [   74.503540] Freeing unused kernel memory: 1168K (ffff8800016dc000 - ffff880001800000)
> [   74.528592] Freeing unused kernel memory: 1556K (ffff880001a7b000 - ffff880001c00000)
> [   74.531566] input: AT Raw Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [   74.581041] __send_signal(17, ffff883ff18d1df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.588753] __send_signal(17, ffff885ff1e87df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.592402] __send_signal(17, ffff887ff18b7df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.599975] __send_signal(17, ffff889ff1f45df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.611401] __send_signal(17, ffff88bff1959df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.619939] __send_signal(17, ffff88dff1f75df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.600332] __send_signal(17, ffff88fff11dddf8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.608839] __send_signal(17, ffff881ff10f7df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.651958] __send_signal(17, ffff883ff190bdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.659443] __send_signal(17, ffff885ff1e87df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.663930] __send_signal(17, ffff887ff18b7df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.672501] __send_signal(17, ffff889ff1f45df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.682406] __send_signal(17, ffff88bff1959df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.689887] __send_signal(17, ffff88dff1f75df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.671456] __send_signal(17, ffff88fff11dddf8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.679483] __send_signal(17, ffff881ff111bdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.720648] __send_signal(17, ffff881ff1139df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.730058] __send_signal(17, ffff885ff1f11df8, ffff883ff22910f0 / 'all_generic_ide', 1, 0)
> [   74.738516] __send_signal(17, ffff883ff1923df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.742990] __send_signal(17, ffff889ff1f45df8, ffff887ff1f110f0 / 'blacklist', 1, 0)
> [   74.750942] __send_signal(17, ffff887ff18e5df8, ffff881ff2c30000 / 'init', 1, 0)
> [   74.765067] __send_signal(17, ffff88dff1f75df8, ffff88bff36d43c0 / 'udev', 1, 0)
> [   74.737987] systemd-udevd[886]: starting version 204
> [   74.843940] scsi 4:0:0:0: CD-ROM            TEAC     DV-W28S-W        J.0A PQ: 0 ANSI: 0
> [   74.856780] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [   74.864226] cdrom: Uniform CD-ROM driver Revision: 3.20
> [   74.870897] sr 4:0:0:0: Attached scsi CD-ROM sr0
> [   74.876105] sr 4:0:0:0: Attached scsi generic sg1 type 5
> [   75.268518] __send_signal(17, ffff887ff1a99df8, ffff881ff1190000 / 'systemd-udevd', 1, 0)
> [   75.924745] __send_signal(17, ffff88fff1265df8, ffff88bff36d43c0 / 'udev', 1, 0)
> [   75.932409] __send_signal(17, ffff88bff19afdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   75.936045] __send_signal(17, ffff887ff2741df8, ffff881ff2c30000 / 'init', 1, 0)
> [   75.942735] __send_signal(17, ffff887ff2237df8, ffff881ff2c30000 / 'init', 1, 0)
> [   75.951754] __send_signal(17, ffff889ff25ffdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   75.960633] __send_signal(17, ffff889ff2533df8, ffff881ff2c30000 / 'init', 1, 0)
> [   75.969671] __send_signal(17, ffff88bff19afdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   75.976364] __send_signal(17, ffff88bff226fdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   75.985163] __send_signal(17, ffff88dff26b7df8, ffff881ff2c30000 / 'init', 1, 0)
> [   75.964610] __send_signal(17, ffff88dff1f75df8, ffff881ff2c30000 / 'init', 1, 0)
> [   75.982484] __send_signal(17, ffff88fff1265df8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.026264] __send_signal(17, ffff883ff19b5df8, ffff881feeade5a0 / 'fixrtc', 1, 0)
> [   76.034015] __send_signal(17, ffff881fee077df8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.037845] __send_signal(17, ffff885ff25cfdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.061528] __send_signal(17, ffff88bff27c7df8, ffff889ff1d3a1e0 / 'resume', 1, 0)
> [   76.069223] __send_signal(17, ffff889ff25ffdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.074561] __send_signal(17, ffff887ff2237df8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.128750] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [   76.136470] __send_signal(17, ffff889ff2533df8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.147712] __send_signal(17, ffff88bff1abbdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.155851] __send_signal(17, ffff88dff2dc7df8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.135300] __send_signal(17, ffff88dff2dcddf8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.176767] __send_signal(15, ffff88fff123feb0, ffff881ff1190000 / 'systemd-udevd', 1, 0)
> [   76.185070] __send_signal(15, ffff88fff123feb0, ffff881ff11310f0 / 'systemd-udevd', 1, 0)
> [   76.185772] __send_signal(17, ffff881ff115bdf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.201536] __send_signal(15, ffff88fff123feb0, ffff881ff12210f0 / 'systemd-udevd', 1, 0)
> [   76.202083] __send_signal(17, ffff881ff11dbdf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.218146] __send_signal(15, ffff88fff123feb0, ffff881ff12221e0 / 'systemd-udevd', 1, 0)
> [   76.218687] __send_signal(17, ffff881ff1251df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.234757] __send_signal(15, ffff88fff123feb0, ffff881ff12232d0 / 'systemd-udevd', 1, 0)
> [   76.235294] __send_signal(17, ffff881ff128bdf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.251368] __send_signal(15, ffff88fff123feb0, ffff881ff12243c0 / 'systemd-udevd', 1, 0)
> [   76.251914] __send_signal(17, ffff881ff12bfdf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.267982] __send_signal(15, ffff88fff123feb0, ffff881ff12254b0 / 'systemd-udevd', 1, 0)
> [   76.268455] __send_signal(17, ffff881ff12e3df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.284673] __send_signal(15, ffff88fff123feb0, ffff881ff12265a0 / 'systemd-udevd', 1, 0)
> [   76.290645] __send_signal(17, ffff881ff130ddf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.301282] __send_signal(15, ffff88fff123feb0, ffff881ff1348000 / 'systemd-udevd', 1, 0)
> [   76.307173] __send_signal(17, ffff881ff1321df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.317817] __send_signal(15, ffff88fff123feb0, ffff881ff13490f0 / 'systemd-udevd', 1, 0)
> [   76.323840] __send_signal(17, ffff881ff1345df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.334511] __send_signal(15, ffff88fff123feb0, ffff881ff134a1e0 / 'systemd-udevd', 1, 0)
> [   76.340489] __send_signal(17, ffff881ff1373df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.351135] __send_signal(15, ffff88fff123feb0, ffff881ff134b2d0 / 'systemd-udevd', 1, 0)
> [   76.357013] __send_signal(17, ffff881ff13a1df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.367726] __send_signal(15, ffff88fff123feb0, ffff881ff134c3c0 / 'systemd-udevd', 1, 0)
> [   76.373594] __send_signal(17, ffff881ff13a5df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.390304] __send_signal(15, ffff88fff123feb0, ffff881ff134d4b0 / 'systemd-udevd', 1, 0)
> [   76.390807] __send_signal(17, ffff881ff13cbdf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.406788] __send_signal(15, ffff88fff123feb0, ffff881ff134e5a0 / 'systemd-udevd', 1, 0)
> [   76.407315] __send_signal(17, ffff881ff13f1df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.423415] __send_signal(15, ffff88fff123feb0, ffff881fee820000 / 'systemd-udevd', 1, 0)
> [   76.423881] __send_signal(17, ffff881ff13f5df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.439999] __send_signal(15, ffff88fff123feb0, ffff881fee8210f0 / 'systemd-udevd', 1, 0)
> [   76.440491] __send_signal(17, ffff881fee81ddf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.456609] __send_signal(15, ffff88fff123feb0, ffff881fee8221e0 / 'systemd-udevd', 1, 0)
> [   76.457169] __send_signal(17, ffff881fee847df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.473219] __send_signal(15, ffff88fff123feb0, ffff881fee8232d0 / 'systemd-udevd', 1, 0)
> [   76.473728] __send_signal(17, ffff881fee86ddf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.489831] __send_signal(15, ffff88fff123feb0, ffff881fee8243c0 / 'systemd-udevd', 1, 0)
> [   76.490314] __send_signal(17, ffff881fee875df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.506441] __send_signal(15, ffff88fff123feb0, ffff881fee8254b0 / 'systemd-udevd', 1, 0)
> [   76.506934] __send_signal(17, ffff881fee89fdf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.523074] __send_signal(15, ffff88fff123feb0, ffff881fee8265a0 / 'systemd-udevd', 1, 0)
> [   76.523578] __send_signal(17, ffff881fee8c5df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.539751] __send_signal(15, ffff88fff123feb0, ffff881fee8f8000 / 'systemd-udevd', 1, 0)
> [   76.540991] __send_signal(17, ffff881fee8f3df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.556278] __send_signal(15, ffff88fff123feb0, ffff881fee8f90f0 / 'systemd-udevd', 1, 0)
> [   76.556853] __send_signal(17, ffff881fee8f7df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.573009] __send_signal(15, ffff88fff123feb0, ffff881fee8fa1e0 / 'systemd-udevd', 1, 0)
> [   76.568217] __send_signal(17, ffff881fee927df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.589581] __send_signal(15, ffff88fff123feb0, ffff881fee8fb2d0 / 'systemd-udevd', 1, 0)
> [   76.557071] __send_signal(17, ffff881fee949df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.606183] __send_signal(15, ffff88fff123feb0, ffff881fee8fc3c0 / 'systemd-udevd', 1, 0)
> [   76.607417] __send_signal(17, ffff881fee96fdf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.622800] __send_signal(15, ffff88fff123feb0, ffff881fee8fd4b0 / 'systemd-udevd', 1, 0)
> [   76.590235] __send_signal(17, ffff881fee977df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.639433] __send_signal(15, ffff88fff123feb0, ffff881fee8fe5a0 / 'systemd-udevd', 1, 0)
> [   76.606763] __send_signal(17, ffff881fee9a3df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.656038] __send_signal(15, ffff88fff123feb0, ffff881fee9f0000 / 'systemd-udevd', 1, 0)
> [   76.657295] __send_signal(17, ffff881fee9cddf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.672572] __send_signal(15, ffff88fff123feb0, ffff881fee9f10f0 / 'systemd-udevd', 1, 0)
> [   76.673118] __send_signal(17, ffff881fee9f9df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.689345] __send_signal(15, ffff88fff123feb0, ffff881fee9f21e0 / 'systemd-udevd', 1, 0)
> [   76.685195] __send_signal(17, ffff881fee9fddf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.705902] __send_signal(15, ffff88fff123feb0, ffff881fee9f32d0 / 'systemd-udevd', 1, 0)
> [   76.707076] __send_signal(17, ffff881feea2ddf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.722424] __send_signal(15, ffff88fff123feb0, ffff881fee9f43c0 / 'systemd-udevd', 1, 0)
> [   76.723044] __send_signal(17, ffff881feea51df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.739107] __send_signal(15, ffff88fff123feb0, ffff881fee9f54b0 / 'systemd-udevd', 1, 0)
> [   76.735020] __send_signal(17, ffff881feea75df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.755749] __send_signal(15, ffff88fff123feb0, ffff881fee9f65a0 / 'systemd-udevd', 1, 0)
> [   76.756929] __send_signal(17, ffff881feea7ddf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.772261] __send_signal(15, ffff88fff123feb0, ffff881feead8000 / 'systemd-udevd', 1, 0)
> [   76.772815] __send_signal(17, ffff881feeaafdf8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.757287] __send_signal(17, ffff881feead7df8, ffff88fff10321e0 / 'systemd-udevd', 1, 0)
> [   76.765742] __send_signal(17, ffff881fee08bdf8, ffff88fff10343c0 / 'udev', 1, 0)
> [   76.806229] __send_signal(17, ffff88fff123fdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.851892] __send_signal(17, ffff883ff19e3df8, ffff88fff10343c0 / 'udev', 1, 0)
> [   76.859490] __send_signal(17, ffff885ff276fdf8, ffff88fff10343c0 / 'udev', 1, 0)
> [   76.862938] __send_signal(17, ffff887ff2151df8, ffff88fff10343c0 / 'udev', 1, 0)
> [   76.870567] __send_signal(17, ffff88fff1aefdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.892224] __send_signal(17, ffff889ff25ffdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.902651] __send_signal(17, ffff88bff191fdf8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.910928] __send_signal(17, ffff88dff2dcddf8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.929763] __send_signal(17, ffff88fff1b6ddf8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.936449] __send_signal(17, ffff88fff1af5df8, ffff881ff2c30000 / 'init', 1, 0)
> [   76.945662] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000200
> [   76.945662] 
> [   76.954779] CPU: 2 PID: 1 Comm: init Not tainted 3.14.0-rc4+ #300
> [   76.960962] Hardware name: FUJITSU-SV PRIMEQUEST 1800E2/SB, BIOS PRIMEQUEST 1000 Series BIOS Version 1.24 09/14/2011
> [   76.971653]  ffff883ff1898000 ffff881ff2c2be28 ffffffff816ca8c5 ffff881ff2c30000
> [   76.979163]  ffffffff819b86a0 ffff881ff2c2bea8 ffffffff816c5c19 ffffffff816d4800
> [   76.986674]  ffff881f00000010 ffff881ff2c2beb8 ffff881ff2c2be58 ffff881ff2c2be78
> [   76.994184] Call Trace:
> [   76.996665]  [<ffffffff816ca8c5>] dump_stack+0x4e/0x68
> [   77.001879]  [<ffffffff816c5c19>] panic+0xd2/0x1f9
> [   77.006738]  [<ffffffff816d4800>] ? _raw_write_unlock_irq+0x30/0x60
> [   77.013099]  [<ffffffff810558f7>] do_exit+0x917/0xa20
> [   77.018224]  [<ffffffff81182e0d>] ? __sb_end_write+0x7d/0x90
> [   77.023963]  [<ffffffff816d4ed8>] ? retint_swapgs+0x13/0x1b
> [   77.029617]  [<ffffffff81055a9f>] do_group_exit+0x4f/0xc0
> [   77.035097]  [<ffffffff81055b27>] SyS_exit_group+0x17/0x20
> [   77.040663]  [<ffffffff816d59e9>] system_call_fastpath+0x16/0x1b
> [   77.050447] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

