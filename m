Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135Ab3GSJz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:55:29 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:35395 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753197Ab3GSJz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:55:26 -0400
From: "Peng, Tao" <tao.peng@emc.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Andreas Dilger <adilger@dilger.ca>
CC: Nathan Rutman <nathan_rutman@xyratex.com>, Peng Tao <bergwolf@gmail.com>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: RE: [lustre mess] is mgc_fs_setup() reachable at all?
Thread-Topic: [lustre mess] is mgc_fs_setup() reachable at all?
Thread-Index: AQHOg5awi2HD5CaMmEqZ+O9dx2oYaJlqsmUAgAAal4OAAGGjgIAAvNAA///OiwA=
Date: Fri, 19 Jul 2013 09:55:05 +0000
Message-ID: <1882637210201641A747464075FFC6490E5A7333@MX101CL02.corp.emc.com>
References: <20130718090835.GZ4165@ZenIV.linux.org.uk>
 <CA+a=Yy49WfQVJAYybUzVvigi9b--kuagqKxBEH+yy0RZSKVnQA@mail.gmail.com>
 <5DD1CAAA-2008-47F9-B3B6-8D342B28D08C@xyratex.com>
 <20130718190703.GB4165@ZenIV.linux.org.uk>
 <3F4C226D-9D3B-46FA-9C8C-55268B2F904F@dilger.ca>
 <20130719081258.GE4165@ZenIV.linux.org.uk>
In-Reply-To: <20130719081258.GE4165@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.32.218.82]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6J9taNE011184

On Fri, Jul 19, 2013 at 4:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Jul 18, 2013 at 02:57:11PM -0600, Andreas Dilger wrote:
>
>> > _THAT_ was going to be a remotely supplied data?  I really hope I've
>> > misparsed what you said above...
>> >
>> > And that still leaves the question about the code path that could
>> > lead to execution of mgc_fs_setup().
>>
>> The KEY_SET_FS is only used in the server code, not on the client.
>> The MGC code is shared between client and server to mount the
>> filesystem and fetch the cluster configuration from the management
>> server.  In the case of a server mount, it also has to mount the
>> underlying block device, which isn't true on the client, so this
>> code is indeed unused.
>
> Wait a minute...  So we have client side of things in staging, with
> parts shared with the server, which is *not* in tree at all?  That
> sounds painful - any changes done to the client code either risk
> to break the server, or have the copies of the shared stuff diverge...
>
Currently we are hoping that the divergent part can be kept small and maintainable. Patches are ported between kernel and external trees to keep them in sync. There are also ongoing work to split client and server code. In external tree, server code are mostly marked by HAVE_SERVER_SUPPORT macro if they are shared with client but not used by client. Currently we removed such code that are not used by client in kernel Lustre but those are mostly whole functions. For the cases like in mgc_fs_setup(), can we use #ifdef HAVE_LUSTRE_SERVER_SUPPORT to mark out the unused code, or keep it as is, or do you want us to remove it completely?

> I honestly have no idea about your plans wrt merging; are you going
> to put the server side of things there as well?
>
Client is first attempted because it is easier to put into kernel, compared with server that still needs patching other pieces of kernel for a few places. I'm not sure about plans for server though. Andreas may know more about server plans.

> Another thing: is your ll_statfs_internal() safe to call right up to
> the moment when client_common_put_super calls lprocfs_unregister_mountpoint?
> Because procfs IO *can* come right until the procfs entry removal;
> said removal will act as a barrier, so it won't leak past the return from
> remove_proc_entry(), but that's it.
>
You are right. It seems problematic. We should really remove procfs entry before cleaning up obd export in client_common_put_super(). Something like below:

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index afae801..8e89311 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -685,6 +685,9 @@ void client_common_put_super(struct super_block *sb)
 	}
 #endif
 
+	/* remove proc entry first to prevent any new callers */
+	lprocfs_unregister_mountpoint(sbi);
+
 	ll_close_thread_shutdown(sbi->ll_lcq);
 
 	cl_sb_fini(sb);
@@ -698,8 +701,6 @@ void client_common_put_super(struct super_block *sb)
 	 * see LU-2543. */
 	obd_zombie_barrier();
 
-	lprocfs_unregister_mountpoint(sbi);
-
 	obd_fid_fini(sbi->ll_md_exp->exp_obd);
 	obd_disconnect(sbi->ll_md_exp);
 	sbi->ll_md_exp = NULL;

> While we are at procfs side of thing, looks like you need exclusion between
> ll_..._seq_write() that clear/set bits in ->ll_flags; at least I haven't
> found anything that would prevent the races among those.
Yes, that part needs to be fixed as well, by taking sbi->ll_lock.

Thanks very much for looking at it. Will send patches to fix the issues.

Thanks,
Tao
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
