Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415Ab3BNKbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:31:10 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16477 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3BNKbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:31:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Feb 2013 02:27:11 -0800
Message-ID: <511CBCE8.9070204@nvidia.com>
Date: Thu, 14 Feb 2013 19:31:04 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: USB list <linux-usb@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Alexandre Courbot <gnurou@gmail.com>
Subject: usb_wwan_write() called while device still being resumed
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I have this pretty weird issue on Android 3.1 kernel and would really 
appreciate some insight that would allow me to figure it out. Could not 
find any reference to a similar problem so I am seeking your advice.

The board features a USB GSM modem using the usb_wwan module. Once in a 
while, when the system resumes from LP0, a NET_RX softirq will be 
triggered while the modem is still being resumed, calling 
usb_wwan_write(). This will cause usb_autopm_get_interface_async() 
inside usb_wwan_write() to fail because the runtime PM disable_depth is 
still equal to 1 since device_resume() has not completed yet. As a 
result, the modem just stops working.

The resume sequence is the device would look like this:

1) device_resume() is called
2) usb_resume() is called
3) usb_resume_both() resumes the device and its 6 serial interfaces (all 
using usb_wwan)
4) device_resume() completes, setting the device as resumed, 
disable_depth is 0

The problem occurs during 3) when, after 1 or 2 of the device's 
interfaces have been resumed (and usb_wwan_resume() called on them), an 
NET_RX softirq is fired that ends up calling usb_wwan_write(). Here is 
the trace when this happens:

[  245.833459] [<c0373040>] (usb_wwan_write+0x3cc/0x400) from 
[<c036e2e8>] (serial_write+0x6c/0xa4)
[  245.842452] [<c036e2e8>] (serial_write+0x6c/0xa4) from [<c0334838>] 
(ppp_async_push+0x150/0x1c0)
[  245.851440] [<c0334838>] (ppp_async_push+0x150/0x1c0) from 
[<c03348cc>] (ppp_async_send+0x24/0x58)
[  245.860516] [<c03348cc>] (ppp_async_send+0x24/0x58) from [<c032fd30>] 
(ppp_push+0x6c/0xb4)
[  245.868981] [<c032fd30>] (ppp_push+0x6c/0xb4) from [<c0331564>] 
(ppp_send_frame+0x384/0x470)
[  245.877601] [<c0331564>] (ppp_send_frame+0x384/0x470) from 
[<c03316ac>] (ppp_xmit_process+0x5c/0xc4)
[  245.886933] [<c03316ac>] (ppp_xmit_process+0x5c/0xc4) from 
[<c0331868>] (ppp_start_xmit+0x154/0x1c4)
[  245.896181] [<c0331868>] (ppp_start_xmit+0x154/0x1c4) from 
[<c04c9640>] (dev_hard_start_xmit+0x288/0x5c4)
[  245.905950] [<c04c9640>] (dev_hard_start_xmit+0x288/0x5c4) from 
[<c04e111c>] (sch_direct_xmit+0xc0/0x1ec)
[  245.915714] [<c04e111c>] (sch_direct_xmit+0xc0/0x1ec) from 
[<c04c9b54>] (dev_queue_xmit+0x1d8/0x4d8)
[  245.925046] [<c04c9b54>] (dev_queue_xmit+0x1d8/0x4d8) from 
[<c04d1f8c>] (neigh_direct_output+0x1c/0x20)
[  245.934644] [<c04d1f8c>] (neigh_direct_output+0x1c/0x20) from 
[<c0524424>] (ip_finish_output.part.9+0x14c/0x350)
[  245.945019] [<c0524424>] (ip_finish_output.part.9+0x14c/0x350) from 
[<c052466c>] (ip_finish_output+0x44/0x48)
[  245.955136] [<c052466c>] (ip_finish_output+0x44/0x48) from 
[<c052509c>] (ip_output+0x100/0x118)
[  245.963951] [<c052509c>] (ip_output+0x100/0x118) from [<c0524784>] 
(ip_local_out+0x38/0x3c)
[  245.972506] [<c0524784>] (ip_local_out+0x38/0x3c) from [<c05248a4>] 
(ip_queue_xmit+0x11c/0x398)
[  245.981414] [<c05248a4>] (ip_queue_xmit+0x11c/0x398) from 
[<c053b928>] (tcp_transmit_skb+0x31c/0x50c)
[  245.990836] [<c053b928>] (tcp_transmit_skb+0x31c/0x50c) from 
[<c053d27c>] (tcp_send_ack+0xd8/0x114)
[  246.000081] [<c053d27c>] (tcp_send_ack+0xd8/0x114) from [<c0532ec4>] 
(__tcp_ack_snd_check+0x78/0xa4)
[  246.009330] [<c0532ec4>] (__tcp_ack_snd_check+0x78/0xa4) from 
[<c0538ddc>] (tcp_rcv_established+0x184/0x6e8)
[  246.019355] [<c0538ddc>] (tcp_rcv_established+0x184/0x6e8) from 
[<c05400a8>] (tcp_v4_do_rcv+0xf8/0x21c)
[  246.028948] [<c05400a8>] (tcp_v4_do_rcv+0xf8/0x21c) from [<c05421ac>] 
(tcp_v4_rcv+0x70c/0x838)
[  246.037740] [<c05421ac>] (tcp_v4_rcv+0x70c/0x838) from [<c051f534>] 
(ip_local_deliver_finish+0x110/0x2fc)
[  246.047504] [<c051f534>] (ip_local_deliver_finish+0x110/0x2fc) from 
[<c051f8e8>] (ip_local_deliver+0xb8/0xc4)
[  246.057618] [<c051f8e8>] (ip_local_deliver+0xb8/0xc4) from 
[<c051f10c>] (ip_rcv_finish+0x158/0x470)
[  246.066780] [<c051f10c>] (ip_rcv_finish+0x158/0x470) from 
[<c051fbf8>] (ip_rcv+0x304/0x3f4)
[  246.075337] [<c051fbf8>] (ip_rcv+0x304/0x3f4) from [<c04c40a0>] 
(__netif_receive_skb+0x2a0/0x514)
[  246.084410] [<c04c40a0>] (__netif_receive_skb+0x2a0/0x514) from 
[<c04c43bc>] (process_backlog+0xa8/0x178)
[  246.094178] [<c04c43bc>] (process_backlog+0xa8/0x178) from 
[<c04c8308>] (net_rx_action+0xd0/0x2b8)
[  246.103336] [<c04c8308>] (net_rx_action+0xd0/0x2b8) from [<c00751d4>] 
(__do_softirq+0xdc/0x278)
[  246.112150] [<c00751d4>] (__do_softirq+0xdc/0x278) from [<c00755bc>] 
(do_softirq+0x60/0x6c)
[  246.120699] [<c00755bc>] (do_softirq+0x60/0x6c) from [<c0075690>] 
(local_bh_enable_ip+0xc8/0xd4)
[  246.129685] [<c0075690>] (local_bh_enable_ip+0xc8/0xd4) from 
[<c061a984>] (_raw_write_unlock_bh+0x48/0x4c)
[  246.139546] [<c061a984>] (_raw_write_unlock_bh+0x48/0x4c) from 
[<c04d4b2c>] (neigh_periodic_work+0x15c/0x1fc)
[  246.149670] [<c04d4b2c>] (neigh_periodic_work+0x15c/0x1fc) from 
[<c008a68c>] (process_one_work+0x174/0x52c)
[  246.159525] [<c008a68c>] (process_one_work+0x174/0x52c) from 
[<c008ab90>] (worker_thread+0x14c/0x3a8)
[  246.168945] [<c008ab90>] (worker_thread+0x14c/0x3a8) from 
[<c008f708>] (kthread+0xac/0xb4)
[  246.177396] [<c008f708>] (kthread+0xac/0xb4) from [<c000fd4c>] 
(kernel_thread_exit+0x0/0x8)

... and then usb_autopm_get_interface_async() fails because 
disable_depth is > 0.

The first interface has an interrupt URB, which is submitted when 
usb_wwan_resume() is called. I suspect it fetches data immediatly after 
and triggers the softirq. From the stack trace it seems that the issue 
happens when trying to send the ACK for received data.

That's unfortunately where my understanding of networking, PM, and USB 
stops. I would really appreciate if someone could explain why this 
interface is processing data even though the device is not completely 
resumed, and how I could avoid this. I have checked the latest upstream 
code for usb_wwan.c and the behavior does not seem to have changed much.

Thanks for any hint,
Alex.

