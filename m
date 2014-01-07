Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaAGUaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 15:30:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22099 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753007AbaAGU3z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 15:29:55 -0500
From: Chris Mason <clm@fb.com>
To: "muthu.lkml@gmail.com" <muthu.lkml@gmail.com>
CC: "kmo@daterainc.com" <kmo@daterainc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@linux.intel.com" <lkp@linux.intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
Thread-Topic: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
Thread-Index: AQHPCL03PcXQz/ImsUiAzg3MZ0ORWpp4zOEAgAAr4ACAAFVnAIAA8PCAgAAEF4A=
Date: Tue, 7 Jan 2014 20:29:47 +0000
Message-ID: <1389126617.23310.19.camel@ret.masoncoding.com>
References: <20140102053101.GA29352@localhost>
	 <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
	 <20140106221036.GE9037@kmo>
	 <CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>
	 <20140107055318.GA19016@localhost>
	 <CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
In-Reply-To: <CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.57.29]
Content-Type: text/plain; charset="utf-7"
Content-ID: <48AD0F3D7F1105459BB718A49E168E80@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-07_07:2014-01-07,2014-01-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=138.697591113007
 compositescore=0.533125042697551 urlsuspect_oldscore=0.533125042697551
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.533125042697551 spamscore=0
 recipient_to_sender_domain_totalscore=29 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401070124
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 12:15 -0800, Muthu Kumar wrote:
+AD4- Thanks Fengguang. Final patch with added comment. BTW, fengguang
+AD4- mentioned that git-am has trouble with the inline patch and +ACI-quilt
+AD4- import+ACI- worked fine for him...
+AD4- 
+AD4- ------------
+AD4- In btrfs+AF8-end+AF8-bio(), we increment bi+AF8-remaining if is+AF8-orig+AF8-bio. If not,
+AD4- we restore the orig+AF8-bio but failed to increment bi+AF8-remaining for
+AD4- orig+AF8-bio, which triggers a BUG+AF8-ON later when bio+AF8-endio is called. Fix
+AD4- is to increment bi+AF8-remaining when we restore the orig bio as well.
+AD4- 

Hi everyone,

Which git tree is this against?  Just Jens or some extra code too?

I'll run some tests here.  My original patch is below (it's slightly
different from Muthu's).

Btrfs is sometimes calling bio+AF8-endio twice on the same bio while
we chain things.  This makes sure we don't trip over new assertions in
fs/bio.c

Signed-off-by: Chris Mason +ADw-clm+AEA-fb.com+AD4-

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 7fcac70..5b30360 100644
--- a/fs/btrfs/check-integrity.c
+-+-+- b/fs/btrfs/check-integrity.c
+AEAAQA- -2289,6 +-2289,10 +AEAAQA- static void btrfsic+AF8-bio+AF8-end+AF8-io(struct bio +ACo-bp, int bio+AF8-error+AF8-status)
 		block +AD0- next+AF8-block+ADs-
 	+AH0- while (NULL +ACEAPQ- block)+ADs-
 
+-	/+ACo-
+-	 +ACo- since we're not using bio+AF8-endio here, we don't need to worry about
+-	 +ACo- the remaining count
+-	 +ACo-/
 	bp-+AD4-bi+AF8-end+AF8-io(bp, bio+AF8-error+AF8-status)+ADs-
 +AH0-
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62176ad..786ddac 100644
--- a/fs/btrfs/disk-io.c
+-+-+- b/fs/btrfs/disk-io.c
+AEAAQA- -1684,7 +-1684,7 +AEAAQA- static void end+AF8-workqueue+AF8-fn(struct btrfs+AF8-work +ACo-work)
 	bio-+AD4-bi+AF8-private +AD0- end+AF8-io+AF8-wq-+AD4-private+ADs-
 	bio-+AD4-bi+AF8-end+AF8-io +AD0- end+AF8-io+AF8-wq-+AD4-end+AF8-io+ADs-
 	kfree(end+AF8-io+AF8-wq)+ADs-
-	bio+AF8-endio(bio, error)+ADs-
+-	bio+AF8-endio+AF8-nodec(bio, error)+ADs-
 +AH0-
 
 static int cleaner+AF8-kthread(void +ACo-arg)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ef48947..a31448f 100644
--- a/fs/btrfs/volumes.c
+-+-+- b/fs/btrfs/volumes.c
+AEAAQA- -5284,9 +-5284,17 +AEAAQA- static void btrfs+AF8-end+AF8-bio(struct bio +ACo-bio, int err)
 		+AH0-
 	+AH0-
 
-	if (bio +AD0APQ- bbio-+AD4-orig+AF8-bio)
+-	if (bio +AD0APQ- bbio-+AD4-orig+AF8-bio) +AHs-
 		is+AF8-orig+AF8-bio +AD0- 1+ADs-
 
+-		/+ACo-
+-		 +ACo- eventually we will call the bi+AF8-endio for the original bio,
+-		 +ACo- make sure that we've properly bumped bi+AF8-remaining to reflect
+-		 +ACo- our chain of endios here
+-		 +ACo-/
+-		atomic+AF8-inc(+ACY-bio-+AD4-bi+AF8-remaining)+ADs-
+-	+AH0-
+-
 	if (atomic+AF8-dec+AF8-and+AF8-test(+ACY-bbio-+AD4-stripes+AF8-pending)) +AHs-
 		if (+ACE-is+AF8-orig+AF8-bio) +AHs-
 			bio+AF8-put(bio)+ADs-
--
To unsubscribe from this list: send the line +ACI-unsubscribe linux-fsdevel+ACI- in
the body of a message to majordomo+AEA-vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

