Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbaIQUmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:42:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:11868 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755801AbaIQUmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:42:13 -0400
Date: Wed, 17 Sep 2014 16:42:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Felipe Balbi <balbi@ti.com>
Cc: <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: bug on ftrace with v3.17-rc5
Message-ID: <20140917164211.41f87ae6@gandalf.local.home>
In-Reply-To: <20140917172211.GD8140@saruman.home>
References: <20140917172211.GD8140@saruman.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014 12:22:11 -0500
Felipe Balbi <balbi@ti.com> wrote:

> Hi,
> 
> I just triggered a bug with trace by using tail on the trace file:
> 
> # tail trace
> [ 2940.039229] Unable to handle kernel paging request at virtual address 814efa9e
> [ 2940.046904] pgd = ec3dc000
> [ 2940.049737] [814efa9e] *pgd=00000000
> [ 2940.053552] Internal error: Oops: 5 [#1] SMP ARM
> [ 2940.058379] Modules linked in: usb_f_acm u_serial g_serial usb_f_uac2 libcomposite configfs xhci_hcd dwc3 udc_core matrix_keypad dwc3_omap lis3lv02d_i2c lis3lv02d input_polldev [last unloaded: g_audio]
> [ 2940.077238] CPU: 0 PID: 3020 Comm: tail Tainted: G        W
> 3.17.0-rc5-dirty #1097
> [ 2940.085596] task: ed1b1040 ti: ed07c000 task.ti: ed07c000
> [ 2940.091258] PC is at strnlen+0x18/0x68
> [ 2940.095177] LR is at 0xfffffffe
> [ 2940.098454] pc : [<c0356df8>]    lr : [<fffffffe>]    psr: a0000013
> [ 2940.098454] sp : ed07ddb0  ip : ed07ddc0  fp : ed07ddbc
> [ 2940.110445] r10: c070ff70  r9 : ed07de70  r8 : 00000000
> [ 2940.115906] r7 : 814efa9e  r6 : ffffffff  r5 : ed4b6087  r4 : ed4b50c7
> [ 2940.122726] r3 : 00000000  r2 : 814efa9e  r1 : ffffffff  r0 : 814efa9e
> [ 2940.129546] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM Segment user
> [ 2940.137000] Control: 10c5387d  Table: ac3dc059  DAC: 00000015
> [ 2940.143006] Process tail (pid: 3020, stack limit = 0xed07c248)
> [ 2940.149098] Stack: (0xed07ddb0 to 0xed07e000)
> [ 2940.153660] dda0:                                     ed07dde4 ed07ddc0 c0359628 c0356dec
> [ 2940.162203] ddc0: 00000000 ed4b50c7 bf03ae9c ed4b6087 bf03ae9e 00000002 ed07de3c ed07dde8
> [ 2940.170740] dde0: c035ab50 c0359600 ffffffff ffffffff ff0a0000 ffffffff ed07de30 ed4b5088
> [ 2940.179275] de00: ed4b50c7 00000fc0 ff0a0004 ffffffff ed4b5088 ed4b5088 00000000 00001000
> [ 2940.187810] de20: 00001008 00000fc0 ed4b5088 00000000 ed07de68 ed07de40 c00f1e64 c035a9c4
> [ 2940.196341] de40: bf03dae0 ed07de70 ed4b4000 ec25b280 ed4b4000 ec25b280 bf03dae0 ed07de9c
> [ 2940.204886] de60: ed07de78 bf033324 c00f1e0c bf03ae9c 814efa9e ed428bc0 814eca3e 00000000
> [ 2940.213428] de80: 814eba3e ed4b4000 03bd1201 c0c34790 ed07ded4 ed07dea0 c00edc0c bf0332d0
> [ 2940.221994] dea0: 000002c7 ed07df10 ed07decc ed07deb8 ed4b4000 0000209c ec278ac0 00000000
> [ 2940.230536] dec0: 00002000 ec0db340 ed07def4 ed07ded8 c00ee7ec c00eda90 c00ee7b0 ec278ac0
> [ 2940.239075] dee0: ed4b4000 000002d5 ed07df44 ed07def8 c018b8d0 c00ee7bc c0166d3c ec278af0
> [ 2940.247621] df00: 0001f090 ed07df78 000002c7 00000000 000002c8 00000000 00000000 ec0db340
> [ 2940.256173] df20: 0001f090 ed07df78 ec0db340 00002000 0001f090 00000000 ed07df74 ed07df48
> [ 2940.264729] df40: c0166e98 c018b5f4 00000001 c018535c 000168c1 00000000 ec0db340 ec0db340
> [ 2940.273284] df60: 00002000 0001f090 ed07dfa4 ed07df78 c01675c4 c0166e0c 000168c1 00000000
> [ 2940.281829] df80: 00002000 0000000a 0001f090 00000003 c000f064 ed07c000 00000000 ed07dfa8
> [ 2940.290365] dfa0: c000ede0 c0167584 00002000 0000000a 00000003 0001f090 00002000 00000000
> [ 2940.298909] dfc0: 00002000 0000000a 0001f090 00000003 7fffe000 0001e1e0 00002004 0000002f
> [ 2940.307445] dfe0: 00000000 beed38ec 000104c8 b6e6397c 40000010 00000003 00000000 00000000
> [ 2940.315992] [<c0356df8>] (strnlen) from [<c0359628>] (string.isra.8+0x34/0xe8)
> [ 2940.323534] [<c0359628>] (string.isra.8) from [<c035ab50>] (vsnprintf+0x198/0x3fc)
> [ 2940.331461] [<c035ab50>] (vsnprintf) from [<c00f1e64>] (trace_seq_printf+0x68/0x94)
> [ 2940.339494] [<c00f1e64>] (trace_seq_printf) from [<bf033324>] (ftrace_raw_output_dwc3_log_request+0x60/0x78 [dwc3])
> [ 2940.350424] [<bf033324>] (ftrace_raw_output_dwc3_log_request [dwc3]) from [<c00edc0c>] (print_trace_line+0x188/0x418)

This shows it bugging with your tracepoint "dwc3_log_request".

+DECLARE_EVENT_CLASS(dwc3_log_request,
+ TP_PROTO(struct dwc3_request *req),
+ TP_ARGS(req),
+ TP_STRUCT__entry(
+ __field(struct dwc3_request *, req)
+ ),
+ TP_fast_assign(
+ __entry->req = req;
+ ),
+ TP_printk("%s: req %p length %u/%u ==> %d",
+ __entry->req->dep->name, __entry->req,
+ __entry->req->request.actual, __entry->req->request.length,
+ __entry->req->request.status
+ )
+);

(Bah, cut and paste from the git web page doesn't format nicely)

Anyway, I take issues with that: __entry->req->request.length,
and all the other "__entry->req->*"

Basically, you saved a pointer in the buffer called "req" and than you
dereference it when you are printing. Does that pointer still exist?

If whatever you assigned "req" to gets freed, you can not dereference
it from the buffer! If you need to save the length and other fields, you
need to do it in the fast assign.

-- Steve



> [ 2940.361507] [<c00edc0c>] (print_trace_line) from [<c00ee7ec>] (s_show+0x3c/0x12c)
> [ 2940.369330] [<c00ee7ec>] (s_show) from [<c018b8d0>] (seq_read+0x2e8/0x4a0)
> [ 2940.376519] [<c018b8d0>] (seq_read) from [<c0166e98>] (vfs_read+0x98/0x158)
> [ 2940.383796] [<c0166e98>] (vfs_read) from [<c01675c4>] (SyS_read+0x4c/0xa0)
> [ 2940.390981] [<c01675c4>] (SyS_read) from [<c000ede0>] (ret_fast_syscall+0x0/0x48)
> [ 2940.398792] Code: e24cb004 e3510000 e241e001 0a000011 (e5d01000) 
> [ 2940.406980] ---[ end trace d8b38370fbb531f3 ]---
> 
> This is basically v3.17-rc5 with some USB patches I'm testing for v3.18,
> including a patch where I added tracepoints to dwc3 [1]
> 
> [1] https://git.kernel.org/cgit/linux/kernel/git/balbi/usb.git/commit/?h=next&id=2c4cbe6e5a9c71408b496e00a78ea9284e98af16
> 

