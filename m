Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3DRLUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:20:19 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:11038 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab3DRLUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:20:14 -0400
From: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>
To: Gerd Hoffmann <kraxel@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>
CC: "Huangweidong (C)" <weidong.huang@huawei.com>,
        kvm list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Luonengjun <luonengjun@huawei.com>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zanghongyong <zanghongyong@huawei.com>,
        Zhanghuanzhong <zhanghuanzhong@huawei.com>,
        "corentin.chary@gmail.com" <corentin.chary@gmail.com>
Subject: reply: [Qemu-devel] reply: reply: qemu crashed when starting
 vm(kvm) with vnc connect
Thread-Topic: reply: [Qemu-devel] reply: reply: qemu crashed when starting
 vm(kvm) with vnc connect
Thread-Index: AQHONpcoRq0GcQVPEEeutms+C+LLNZjbOfWAgACbXhA=
Date: Thu, 18 Apr 2013 11:19:54 +0000
Message-ID: <D3E216785288A145B7BC975F83A2ED103FE1E610@szxeml556-mbx.china.huawei.com>
References: <D3E216785288A145B7BC975F83A2ED103FE154C1@szxeml556-mbx.china.huawei.com>
 <20130405063456.GA27569@stefanha-thinkpad.redhat.com>
 <D3E216785288A145B7BC975F83A2ED103FE16528@szxeml556-mbx.china.huawei.com>
 <20130408105052.GC12076@stefanha-thinkpad.redhat.com>
 <D3E216785288A145B7BC975F83A2ED103FE16749@szxeml556-mbx.china.huawei.com>
 <20130411092958.GF8904@stefanha-thinkpad.redhat.com>
 <516FBBF7.1080400@redhat.com>
In-Reply-To: <516FBBF7.1080400@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.135.68.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Mon, Apr 08, 2013 at 12:27:06PM +0000, Zhanghaoyu (A) wrote:
> >> On Sun, Apr 07, 2013 at 04:58:07AM +0000, Zhanghaoyu (A) wrote:
> >>>>>> I start a kvm VM with vnc(using the zrle protocol) connect, sometimes qemu program crashed during starting period, received signal SIGABRT.
> >>>>>> Trying about 20 times, this crash may be reproduced.
> >>>>>> I guess the cause memory corruption or double free.
> >>>>>
> >>>>> Which version of QEMU are you running?
> >>>>>
> >>>>> Please try qemu.git/master.
> 
> Please try again with latest master, might be fixed meanwhile.
> 
> If it still happens pleas provide full qemu and vnc client command lines.
> 
> >> backtrace from core file is shown as below:
> >>
> >> Program received signal SIGABRT, Aborted.
> 
> >> #8  0x00007f32efd26d07 in vnc_disconnect_finish (vs=0x7f32f0c762d0)
> >>     at ui/vnc.c:1050
> 
> Do you have a vnc client connected?  Do you close it?
> 
I have a vnc client connected, it was auto closed while qemu crashed.

> Any errors reported by the vnc client (maybe it disconnects due to an error in the data stream)?
> 
No errors reported by the vnc client, just popup a reconnect window.

And, I have tried to fix this bug, not reproduce this crash after tried about 100 times, patch is shown as below,
--- a/ui/vnc-jobs.c     2013-04-18 20:10:07.000000000 +0800
+++ b/ui/vnc-jobs.c     2013-04-18 20:14:06.000000000 +0800
@@ -234,7 +234,6 @@ static int vnc_worker_thread_loop(VncJob
         vnc_unlock_output(job->vs);
         goto disconnected;
     }
-    vnc_unlock_output(job->vs);

     /* Make a local copy of vs and switch output buffers */
     vnc_async_encoding_start(job->vs, &vs);
@@ -252,6 +251,8 @@ static int vnc_worker_thread_loop(VncJob

         if (job->vs->csock == -1) {
             vnc_unlock_display(job->vs->vd);
+            vnc_async_encoding_end(job->vs, &vs);
+            vnc_unlock_output(job->vs);
             goto disconnected;
         }

@@ -269,7 +270,6 @@ static int vnc_worker_thread_loop(VncJob
     vs.output.buffer[saved_offset] = (n_rectangles >> 8) & 0xFF;
     vs.output.buffer[saved_offset + 1] = n_rectangles & 0xFF;

-    vnc_lock_output(job->vs);
     if (job->vs->csock != -1) {
         buffer_reserve(&job->vs->jobs_buffer, vs.output.offset);
         buffer_append(&job->vs->jobs_buffer, vs.output.buffer,
@@ -278,6 +278,8 @@ static int vnc_worker_thread_loop(VncJob
         vnc_async_encoding_end(job->vs, &vs);

        qemu_bh_schedule(job->vs->bh);
+    } else {
+        vnc_async_encoding_end(job->vs, &vs);
     }
     vnc_unlock_output(job->vs);

Thanks,
Zhang Haoyu
