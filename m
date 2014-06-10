Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaFJQJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:09:15 -0400
Received: from lekensteyn.nl ([178.21.112.251]:59110 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaFJQJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:09:13 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: linux-usb <linux-usb@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [v3.13,v3.15] XHCI breaks suspend, causes overheating
Date: Tue, 10 Jun 2014 18:09:09 +0200
Message-ID: <2069512.HEtRUnkKYs@al>
User-Agent: KMail/4.13.1 (Linux/3.15.0-rc8-custom-00058-gd2cfd31; KDE/4.13.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Score: -0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I do not often suspend my laptop with a device inserted on the USB 3.0
port, but when I did last night, it trigged an immediate wake up. Not
only that, but after resume, some kworkers were hogging CPU. Another
problem is that the laptop overheats in some cases (see end of mail).

Some details:
Distribution: Arch Linux x86_64
USB peripheral: Samsung S3 (GT-i9300) phone
USB HCD: 02:00.0 USB controller [0c03]: NEC Corporation uPD720200 USB 3.0 Host Controller [1033:0194] (rev 03)
Kernel: v3.15-rc8-105-gc593e89 (also confirmed for v3.13.6, other kernels have not been tested)

I managed to get the following backtrace with SysRq + l:

    NMI backtrace for cpu 0
    CPU: 0 PID: 11849 Comm: kworker/0:2 Tainted: G           O  3.15.0-rc8-custom-00058-gd2cfd31 #1
    Hardware name: CLEVO CO.                        B7130                           /B7130                           , BIOS 6.00 08/27/2010
    Workqueue: pm pm_runtime_work
    <..>
    [<ffffffff815f8bbf>] ? _raw_spin_unlock_irqrestore+0x5f/0x80
    [<ffffffffa019b54b>] xhci_hub_control+0xbb/0x1450 [xhci_hcd]
    [<ffffffff81475cfc>] ? usb_hcd_submit_urb+0x2dc/0xa80
    [<ffffffff81475de7>] usb_hcd_submit_urb+0x3c7/0xa80
    [<ffffffff8109f535>] ? mark_held_locks+0x75/0xa0
    [<ffffffff810a4b91>] ? __raw_spin_lock_init+0x21/0x60
    [<ffffffff8109d1f1>] ? lockdep_init_map+0x61/0x530
    [<ffffffff814776e2>] usb_submit_urb+0x372/0x600
    [<ffffffff814780df>] usb_start_wait_urb+0x5f/0x150
    [<ffffffff810821ed>] ? get_parent_ip+0xd/0x50
    [<ffffffff81478295>] usb_control_msg+0xc5/0x110
    [<ffffffff8146b7cc>] hub_port_status+0x7c/0x120
    [<ffffffff8146d599>] hub_activate+0xc9/0x620
    [<ffffffff8109f6bd>] ? trace_hardirqs_on_caller+0x15d/0x200
    [<ffffffff8146dc01>] hub_resume+0x31/0x70
    [<ffffffff8147b626>] usb_resume_interface.isra.5+0xb6/0x120
    [<ffffffff8147b788>] usb_suspend_both+0xf8/0x1f0
    [<ffffffff8147cb83>] usb_runtime_suspend+0x33/0x80
    [<ffffffff8147cb50>] ? usb_probe_interface+0x330/0x330
    [<ffffffff814174f2>] __rpm_callback+0x32/0x70
    [<ffffffff81417556>] rpm_callback+0x26/0xa0
    [<ffffffff814180d1>] rpm_suspend+0x111/0x660
    [<ffffffff81418e3d>] __pm_runtime_suspend+0x5d/0x90
    [<ffffffff8147cbf0>] ? usb_runtime_resume+0x20/0x20
    [<ffffffff8147cc1a>] usb_runtime_idle+0x2a/0x40
    [<ffffffff814174f2>] __rpm_callback+0x32/0x70
    [<ffffffff8141898a>] rpm_idle+0x27a/0x310
    [<ffffffff8141947f>] pm_runtime_work+0xbf/0xd0
    [<ffffffff8106bb54>] process_one_work+0x1d4/0x560
    [<ffffffff8106baf4>] ? process_one_work+0x174/0x560
    [<ffffffff8106c93c>] worker_thread+0x12c/0x3d0
    [<ffffffff8106c810>] ? manage_workers.isra.23+0x2e0/0x2e0
    [<ffffffff810733d6>] kthread+0xf6/0x110
    [<ffffffff810732e0>] ? kthread_create_on_node+0x200/0x200
    [<ffffffff8160152c>] ret_from_fork+0x7c/0xb0
    [<ffffffff810732e0>] ? kthread_create_on_node+0x200/0x200

/proc/../stack was not usable, it just showed start_worker (iirc) on
top. `perf report` mentions kworker and khubd as top users with
call traces corresponding to the above backtrace. CPU usage increased a
bit, but the machine was "kind of usable":

    root     11856  1.2  0.0      0     0 ?        S    00:51   0:10 [kworker/0:3]
    peter      555  1.8  1.1 3085412 87532 ?       Sl   Jun09   1:48 kwin
    root         3  1.9  0.0      0     0 ?        S    Jun09   1:54 [ksoftirqd/0]
    root        14  1.9  0.0      0     0 ?        S    Jun09   1:53 [ksoftirqd/1]
    peter      561  2.1  2.4 3373080 193416 ?      Sl   Jun09   2:06 kdeinit4: plasma-desktop [kdeinit]
    root     11707  2.4  0.0      0     0 ?        S    00:36   0:40 [kworker/1:3]
    root       354  2.5  1.0 312392 82996 tty7     Ssl+ Jun09   2:27 /usr/bin/X :0 vt7 -nolisten tcp -auth /var/run/xauth/A:0-dfgwjb
    root        39  4.5  0.0      0     0 ?        S    Jun09   4:24 [khubd]
    root     11629 12.9  0.0      0     0 ?        S    00:33   4:02 [kworker/1:2]
    root     12076 14.6  0.0      0     0 ?        S    01:02   0:17 [kworker/1:0]
    root     11849 16.5  0.0      0     0 ?        S    00:44   3:25 [kworker/0:2]

In an attempt to get more details, I executed:

    echo workqueue:workqueue_queue_work > tracing/set_event
    cat /sys/kernel/debug/tracing/trace_pipe | pv > /tmp/trace.txt

When the bug is triggered, I see 100k events/s with lines such as:

    khubd-39    [000] d..3  7342.846004: workqueue_queue_work: work struct=ffff8800ae0f0ab8 function=pm_runtime_work workqueue=ffff8802326bde00 req_cpu=256 cpu=0

Attempts to suspend the laptop again failed consistently. After some
tries, the laptop began to beep (presumably thermal limits). I have
never heard such beeps before, the laptop has never been overheating.



Today, I tried to reproduce this bug again. The reproduction steps are:

 1. Start the ADB server (`adb shell`). There is no device connected
    yet.
 2. Connect phone to USB 3.0 port (USB debugging is enabled on the
    Android phone).
 3. Try to suspend.
 4. If it wakes up again, try to suspend again. Be sure that the USB
    device is recognized by the laptop, and that the connection is seen
    by the phone as well.

Expected results: laptop should sleep, phone may (or may not) continue
charging.

Actual results:
 - laptop wakes up immediately.
 - (case 1) kworkers are hogging CPU (seen on v3.15-rc8-ish and 3.13.6).
 - (case 2) Temperature raises (I have seen seen 110 degree Celsius
   before I quickly shut the laptop via the menu. Normal temperature is
   between 40-50 °C). Looking in `ps`, I see over 100 kworker processes.

Other information:
When the bug (case 1) occurs, usbmon (via dumpcap) records 63k packets/sec:

  5 0.000201000 16:40:27.647347000          1.1 0x00000001 host         64  URB_INTERRUPT in
  6 0.000242000 16:40:27.647388000         host 0xffffffff 1.0          64  GET_STATUS Request     [Port 1]
  7 0.000272000 16:40:27.647418000          1.0 0x00000000 host         68  GET_STATUS Response    [Port 1]
  8 0.000280000 16:40:27.647426000         host 0xffffffff 1.0          64  GET_STATUS Request     [Port 2]
  9 0.000288000 16:40:27.647434000          1.0 0x00000000 host         68  GET_STATUS Response    [Port 2]
 10 0.000294000 16:40:27.647440000         host 0xffffffff 1.1          64  URB_INTERRUPT in

In case 2, ps looks like:

    root       886  0.0  0.0      0     0 ?        S    17:03   0:00 [kworker/3:2]
    root       887  0.0  0.0      0     0 ?        S    17:03   0:00 [kworker/1:0]
    root       888  0.0  0.0      0     0 ?        S    17:03   0:00 [kworker/2:0]
    root       889  0.0  0.0      0     0 ?        S    17:03   0:00 [kworker/0:1]
    root       936  0.0  0.0      0     0 ?        S    17:04   0:00 [kworker/u8:0]
    root       937  0.0  0.0      0     0 ?        S    17:04   0:00 [kworker/u8:1]
    root       938  0.0  0.0      0     0 ?        S    17:04   0:00 [kworker/u8:2]
    root       939  0.0  0.0      0     0 ?        S    17:04   0:00 [kworker/u8:5]
    root       940  0.0  0.0      0     0 ?        S    17:04   0:00 [kworker/u8:6]
    root       941  0.0  0.0      0     0 ?        S    17:04   0:00 [kworker/u8:7]
    root       942  0.0  0.0      0     0 ?        S    17:04   0:00 [kworker/u8:8]
    root       943  0.0  0.0      0     0 ?        S    17:04   0:00 [kworker/u8:9]
    root       944  0.0  0.0      0     0 ?        S    17:04   0:00 [kworker/u8:10]
    root       945  0.0  0.0      0     0 ?        S    17:04   0:00 [kworker/u8:11]
    root       946  0.0  0.0      0     0 ?        S    17:04   0:00 [kworker/u8:12]

tail of dmesg when overheating (for Arch Linux's 3.13.6 kernel):

    intel ips 0000:00:1f.6: ME failed to update for more than 1s, likely hung
    intel ips 0000:00:1f.6: ME failed to update for more than 1s, likely hung
    intel ips 0000:00:1f.6: ME failed to update for more than 1s, likely hung
    intel ips 0000:00:1f.6: ME failed to update for more than 1s, likely hung

Any ideas what could be wrong? I can provide more details if needed,
such as perf.data, usbmon3.pcapng, trace.txt, etc.

Kind regards,
Peter

