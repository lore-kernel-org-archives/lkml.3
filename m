Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaHZR0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:26:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31696 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbaHZR0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:26:33 -0400
Message-ID: <53FCC343.1040607@fb.com>
Date: Tue, 26 Aug 2014 13:26:27 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs for rc3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-26_07:2014-08-26,2014-08-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=5.5143761779064e-10 kscore.compositescore=0
 circleOfTrustscore=28.9261618248808 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408260193
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull our fixes from my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The biggest of these comes from Liu Bo, who tracked down a hang
we've been hitting since moving to kernel workqueues (it's a btrfs bug,
not in the generic code).  His patch needs backporting to 3.16 and 3.15
stable, which I'll send once this is in.

Otherwise these are assorted fixes.  Most were integrated last week
during KS, but I wanted to give everyone the chance to test the result,
so I waited for rc2 to come out before sending.

Miao Xie (7) commits (+28/-22):
    Btrfs: fix unzeroed members in fs_devices when creating a fs from seed fs (+3/-0)
    Btrfs: don't consider the missing device when allocating new chunks (+2/-14)
    Btrfs: Fix the problem that the replace destroys the seed filesystem (+6/-2)
    Btrfs: don't write any data into a readonly device when scrub (+11/-0)
    Btrfs: Fix wrong device size when we are resizing the device (+3/-2)
    Btrfs: fix put dio bio twice when we submit dio bio fail (+2/-3)
    Btrfs: fix wrong missing device counter decrease (+1/-1)

Filipe Manana (5) commits (+72/-38):
    Btrfs: ensure tmpfile inode is always persisted with link count of 0 (+15/-0)
    Btrfs: race free update of commit root for ro snapshots (+36/-33)
    Btrfs: clone, don't create invalid hole extent map (+2/-1)
    Btrfs: don't monopolize a core when evicting inode (+6/-0)
    Btrfs: fix hole detection during file fsync (+13/-4)

Liu Bo (3) commits (+143/-62):
    Btrfs: fix task hang under heavy compressed write (+141/-61)
    Btrfs: fix crash on endio of reading corrupted block (+1/-0)
    Btrfs: fix regression of btrfs device replace (+1/-1)

Anand Jain (2) commits (+48/-1):
    Btrfs: device_list_add() should not update list when mounted (+27/-0)
    btrfs: check generation as replace duplicates devid+uuid (+21/-1)

Qu Wenruo (2) commits (+7/-8):
    btrfs: Return right extent when fiemap gives unaligned offset and len. (+2/-2)
    btrfs: Use right extent length when inserting overlap extent map. (+5/-6)

Wang Shilong (2) commits (+4/-1):
    Btrfs: fix wrong write range for filemap_fdatawrite_range() (+2/-1)
    Btrfs: fix wrong extent mapping for DirectIO (+2/-0)

Chris Mason (1) commits (+9/-1):
    Btrfs: fix filemap_flush call in btrfs_file_release

Eric Sandeen (1) commits (+1/-1):
    btrfs: fix leak in qgroup_subtree_accounting() error path

chandan (1) commits (+1/-2):
    Btrfs: fill_holes: Fix slot number passed to hole_mergeable() call.

Total: (24) commits

 fs/btrfs/async-thread.c  |  44 +++++++++++++++----
 fs/btrfs/async-thread.h  |  28 +++++++++++-
 fs/btrfs/delayed-inode.c |   4 +-
 fs/btrfs/disk-io.c       |  56 +++++++++++++-----------
 fs/btrfs/extent-tree.c   |  23 +++-------
 fs/btrfs/extent_io.c     |   5 ++-
 fs/btrfs/file.c          |  17 +++++---
 fs/btrfs/inode.c         | 109 ++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/ioctl.c         |  36 +---------------
 fs/btrfs/ordered-data.c  |   1 +
 fs/btrfs/qgroup.c        |   3 +-
 fs/btrfs/raid56.c        |   9 ++--
 fs/btrfs/reada.c         |   3 +-
 fs/btrfs/scrub.c         |  25 ++++++++---
 fs/btrfs/sysfs.c         |   2 +-
 fs/btrfs/tree-log.c      |  17 ++++++--
 fs/btrfs/volumes.c       |  65 +++++++++++++++++++++++++---
 17 files changed, 312 insertions(+), 135 deletions(-)
