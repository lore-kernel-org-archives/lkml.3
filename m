Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907Ab3ICKRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 06:17:01 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:35232 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759887Ab3ICKQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 06:16:59 -0400
Message-ID: <5225B716.3090708@colorfullife.com>
Date: Tue, 03 Sep 2013 12:16:54 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <dave.bueso@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
        Rik van Riel <riel@redhat.com>,
        Jonathan Gonzalez <jgonzalez@linets.cl>
Subject: Re: ipc-msg broken again on 3.11-rc7?
References: <CA+icZUXuw7QBn4CPLLuiVUjHin0m6GRdbczGw=bZY+Z60sXNow@mail.gmail.com> <CA+icZUUn-r8iq6TVMAKmgJpQm4FhOE4b4QN_Yy=1L=0Up=rkBA@mail.gmail.com> <52205597.3090609@synopsys.com> <CA+icZUW=YXMC_2Qt=cYYz6w_fVW8TS4=Pvbx7BGtzjGt+31rLQ@mail.gmail.com> <C2D7FE5348E1B147BCA15975FBA230751411CB@IN01WEMBXA.internal.synopsys.com> <CALE5RAvaa4bb-9xAnBe07Yp2n+Nn4uGEgqpLrKMuOE8hhZv00Q@mail.gmail.com> <CAMJEocr1SgxQw0bEzB3Ti9bvRY74TE5y9e+PLUsAL1mJbK=-ew@mail.gmail.com> <CA+55aFy8tbBpac57fU4CN3jMDz46kCKT7+7GCpb18CscXuOnGA@mail.gmail.com> <C2D7FE5348E1B147BCA15975FBA230751413F4@IN01WEMBXA.internal.synopsys.com> <5224BCF6.2080401@colorfullife.com> <C2D7FE5348E1B147BCA15975FBA23075141642@IN01WEMBXA.internal.synopsys.com> <5225A466.2080303@colorfullife.com> <C2D7FE5348E1B147BCA15975FBA2307514165E@IN01WEMBXA.internal.synopsys.com> <5225AA8D.6080403@colorfullife.com> <C2D7FE5348E1B147BCA15975FBA2307514168F@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307514168F@IN01WEMBXA.internal.synopsys.com>
Content-Type: multipart/mixed;
 boundary="------------030608050605010303060001"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030608050605010303060001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Vineet,

On 09/03/2013 11:51 AM, Vineet Gupta wrote:
> On 09/03/2013 02:53 PM, Manfred Spraul wrote:
>>
>> The access to msq->q_cbytes is not protected.
>>
>> Vineet, could you try to move the test for free space after ipc_lock?
>> I.e. the lock must not get dropped between testing for free space and
>> enqueueing the messages.
> Hmm, the code movement is not trivial. I broke even the simplest of cases (patch
> attached). This includes the additional change which Linus/Davidlohr had asked for.
The attached patch should work. Could you try it?

--
     Manfred

--------------030608050605010303060001
Content-Type: text/plain; charset=UTF-8;
 name="patch-ipcmsg-wip"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch-ipcmsg-wip"

diff --git a/ipc/msg.c b/ipc/msg.c
index 9f29d9e..b65fdf1 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -680,16 +680,18 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 		goto out_unlock1;
 	}
 
+	ipc_lock_object(&msq->q_perm);
+
 	for (;;) {
 		struct msg_sender s;
 
 		err = -EACCES;
 		if (ipcperms(ns, &msq->q_perm, S_IWUGO))
-			goto out_unlock1;
+			goto out_unlock0;
 
 		err = security_msg_queue_msgsnd(msq, msg, msgflg);
 		if (err)
-			goto out_unlock1;
+			goto out_unlock0;
 
 		if (msgsz + msq->q_cbytes <= msq->q_qbytes &&
 				1 + msq->q_qnum <= msq->q_qbytes) {
@@ -699,10 +701,9 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 		/* queue full, wait: */
 		if (msgflg & IPC_NOWAIT) {
 			err = -EAGAIN;
-			goto out_unlock1;
+			goto out_unlock0;
 		}
 
-		ipc_lock_object(&msq->q_perm);
 		ss_add(msq, &s);
 
 		if (!ipc_rcu_getref(msq)) {
@@ -730,10 +731,7 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 			goto out_unlock0;
 		}
 
-		ipc_unlock_object(&msq->q_perm);
 	}
-
-	ipc_lock_object(&msq->q_perm);
 	msq->q_lspid = task_tgid_vnr(current);
 	msq->q_stime = get_seconds();
 

--------------030608050605010303060001--
