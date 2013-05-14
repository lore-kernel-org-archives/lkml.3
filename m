Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab3ENTJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 15:09:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23743 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3ENTJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 15:09:49 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=K9uRuNqwL0EA:10 a=xpG5au4uAAAA:8 a=Q_H5z4C_nENv4zizw70A:9 a=QEXdDO2ut3YA:10 a=nQwg26TaHBUA:10 a=wcHngVRCsZMdY4_A:21 a=nzFTkYqKDlugSXEy:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368558586.6828.53.camel@gandalf.local.home>
Subject: Re: V3.10-rc1 memory leak
From: Steven Rostedt <rostedt@goodmis.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 14 May 2013 15:09:46 -0400
In-Reply-To: <51912567.6090507@lwfinger.net>
References: <51912567.6090507@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 15:06 -0400, Larry Finger wrote:
> Using v3.10-rc1-68-g2d3ec09, I am getting many instances of the following from 
> kmemleak:
> 
> unreferenced object 0xffff8800b546dc30 (size 48):
>    comm "systemd-udevd", pid 2181, jiffies 4294899141 (age 274.096s)
>    hex dump (first 32 bytes):
>      00 dc 46 b5 00 88 ff ff d0 ff 5b a0 ff ff ff ff  ..F.......[.....
>      1c 3b 5b a0 ff ff ff ff 12 3a 5b a0 ff ff ff ff  .;[......:[.....
>    backtrace:
>      [<ffffffff81432e81>] kmemleak_alloc+0x21/0x50
>      [<ffffffff81143c2b>] kmem_cache_alloc+0x11b/0x270
>      [<ffffffff810e9ee0>] __trace_define_field+0x40/0xd0
>      [<ffffffff810e9fc5>] trace_define_field+0x55/0x70
>      [<ffffffffa05e6ba0>] 0xffffffffa05e6ba0
>      [<ffffffff810ea735>] event_create_dir+0x2e5/0x480
>      [<ffffffff810ea920>] __trace_add_new_event+0x50/0x80
>      [<ffffffff810eacf9>] __add_event_to_tracers+0x69/0xc0
>      [<ffffffff810eb4e1>] trace_module_notify+0x1e1/0x2f0
>      [<ffffffff8106e8f5>] notifier_call_chain+0x55/0x110
>      [<ffffffff8106eb27>] __blocking_notifier_call_chain+0x67/0xc0
>      [<ffffffff8106eb91>] blocking_notifier_call_chain+0x11/0x20
>      [<ffffffff810af792>] load_module+0x19e2/0x24b0
>      [<ffffffff810b0317>] SyS_init_module+0xb7/0xe0
>      [<ffffffff814499d2>] system_call_fastpath+0x16/0x1b
>      [<ffffffffffffffff>] 0xffffffffffffffff
> 
> These appear to be real leaks, but I am not familiar with this section of the 
> code, and they could be false indications.

They are false positives. Yesterday and today I've been looking at these
trying to find where the leak is. I actually discovered a leak elsewhere
that's been there for a while (and fixed it), but it had nothing to do
with these.

Finally, as I was suspecting that these were false positives, I broke
down and added the following code:

+++ b/kernel/trace/trace_events.c
@@ -863,15 +863,15 @@ static int f_show(struct seq_file *m, void *v)
                array_descriptor = NULL;
 
        if (!array_descriptor)
-               seq_printf(m, "\tfield:%s %s;\toffset:%u;\tsize:%u;\tsigned:%d;
+               seq_printf(m, "\tfield:%s %s;\toffset:%u;\tsize:%u;\tsigned:%d;
                           field->type, field->name, field->offset,
-                          field->size, !!field->is_signed);
+                          field->size, !!field->is_signed, field);
        else
-               seq_printf(m, "\tfield:%.*s %s%s;\toffset:%u;\tsize:%u;\tsigned
+               seq_printf(m, "\tfield:%.*s %s%s;\toffset:%u;\tsize:%u;\tsigned
                           (int)(array_descriptor - field->type),
                           field->type, field->name,
                           array_descriptor, field->offset,
-                          field->size, !!field->is_signed);
+                          field->size, !!field->is_signed, field);
 

Which adds the field pointer to the output of the fields in the format
files. And sure enough, it proved to be a false positive:

# cat /debug/kmemleak
unreferenced object 0xffff8800769f7438 (size 48):
  comm "modprobe", pid 881, jiffies 4294691017 (age 716.781s)
  hex dump (first 32 bytes):
    90 98 04 a0 ff ff ff ff 08 74 9f 76 00 88 ff ff  .........t.v....
    b6 52 04 a0 ff ff ff ff ba 52 04 a0 ff ff ff ff  .R.......R......
  backtrace:
    [<ffffffff814b52ef>] kmemleak_alloc+0x73/0x98
    [<ffffffff8111ffcc>] kmemleak_alloc_recursive.constprop.42+0x16/0x18
    [<ffffffff8112092f>] kmem_cache_alloc+0xb9/0x142
    [<ffffffff810d0e2e>] __trace_define_field+0x3c/0xbd
    [<ffffffff810d0f0c>] trace_define_field+0x5d/0x5f
    [<ffffffffa005a166>] 0xffffffffa005a166
    [<ffffffff810d19dc>] event_create_dir+0x31c/0x381
    [<ffffffff810d1ae3>] __add_event_to_tracers+0xa2/0xbd
    [<ffffffff810d1cc6>] trace_module_notify+0x1c8/0x26f
    [<ffffffff814d219d>] notifier_call_chain+0x37/0x63
    [<ffffffff8105c29c>] __blocking_notifier_call_chain+0x4b/0x60
    [<ffffffff8105c2c5>] blocking_notifier_call_chain+0x14/0x16
    [<ffffffff8108fe59>] load_module+0x1d55/0x20a9
    [<ffffffff81090286>] SyS_init_module+0xd9/0xdb
    [<ffffffff814d5694>] tracesys+0xdd/0xe2
    [<ffffffffffffffff>] 0xffffffffffffffff
[...]

# find /debug/tracing/events/ -name format |xargs grep ffff8800769f7438
/debug/tracing/events/drm/drm_vblank_event_delivered/format:	field:pid_t pid;	offset:8;	size:4;	signed:1;ffff8800769f7438

Thus, what it is complaining about being leaked, is currently being
used.

I guess it's because the fields are stored on the "event class"
structure of the module. That is, the struct ftrace_event_class, which
is part of the module data section:

struct ftrace_event_class {
        char                    *system;
        void                    *probe;
#ifdef CONFIG_PERF_EVENTS
        void                    *perf_probe;
#endif
        int                     (*reg)(struct ftrace_event_call *event,
                                       enum trace_reg type, void *data);
        int                     (*define_fields)(struct ftrace_event_call *);
        struct list_head        *(*get_fields)(struct ftrace_event_call *);
        struct list_head        fields;
        int                     (*raw_init)(struct ftrace_event_call *);
};


The list_head fields holds the fields and these are used to print out
the formats. For some reason, kmemleak is missing that the fields are
being assigned to this list on module load.

Catalin, have any idea why kmemleak is not detecting that the field is
being referenced?

kernel/trace/trace_events.c: __trace_define_field()

        list_add(&field->link, head);

-- Steve


> 
> This mail is sent to all authors of patches incorporated in 
> kernel/trace/trace_events.c in 2013. Kernel 3.9 did not show this problem.


