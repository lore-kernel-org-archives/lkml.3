Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab3EOQip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:38:45 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:43672 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759374Ab3EOQio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:38:44 -0400
X-WSS-ID: 0MMUM8H-0B-0PH-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
From: "Jim Schutt" <jaschut@sandia.gov>
To: elder@inktank.com
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jim Schutt" <jaschut@sandia.gov>
Subject: [PATCH v2 0/3] ceph: fix might_sleep while atomic
Date: Wed, 15 May 2013 10:38:11 -0600
Message-ID: <1368635894-114707-1-git-send-email-jaschut@sandia.gov>
X-Mailer: git-send-email 1.7.8.2
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379,
 Antispam-Data: 2013.5.15.163017
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report=' MULTIPLE_RCPTS 0.1,
 HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0,
 BODY_SIZE_1700_1799 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0,
 BODY_SIZE_7000_LESS 0, DATE_TZ_NA 0, URI_ENDS_IN_HTML 0, __ANY_URI 0,
 __CP_URI_IN_BODY 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_X_MAILER 0,
 __MIME_TEXT_ONLY 0, __MULTIPLE_RCPTS_CC_X2 0, __SANE_MSGID 0,
 __SUBJ_ALPHA_END 0, __TO_MALFORMED_2 0, __TO_NO_NAME 0, __URI_NO_MAILTO
 0, __URI_NS '
X-TMWD-Spam-Summary: TS=20130515163826; ID=1; SEV=2.3.1;
 DFV=B2013022509; IFV=NA; AIF=B2013022509; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230332E35313933424130322E303038393A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2013022509_5.03.0010
MIME-Version: 1.0
X-WSS-ID: 7D8D65882IW2829881-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes an issue where encode_caps_cb() ends up
calling kmap() while holding a spinlock.

The original patch (http://www.spinics.net/lists/ceph-devel/msg14573.html)
was expanded to fix some other outstanding issues noticed by Alex Elder
in his review.

Changes from the original version:

 - clean up a comment
 - add missing calls to cpu_to_le32()
 - eliminate unnecessary loop around calls to ceph_pagelist_append()
 - only loop on calls to ceph_count_locks() and ceph_encode_locks_to_buffer()
     if the number of locks changes; exit on other errors
 - return proper error code from encode_caps_cb() if kmalloc fails

In his review, Alex mentioned that he hadn't checked that num_fcntl_locks
and num_flock_locks were properly decoded on the server side, from a le32
over-the-wire type to a cpu type.  I checked, and AFAICS it is done; those
interested can consult Locker::_do_cap_update() in src/mds/Locker.cc and
src/include/encoding.h in the Ceph server code (git://github.com/ceph/ceph).

I also checked the server side for flock_len decoding, and I believe that
also happens correctly, by virtue of having been declared __le32 in
struct ceph_mds_cap_reconnect, in src/include/ceph_fs.h.

Jim Schutt (3):
  ceph: fix up comment for ceph_count_locks() as to which lock to hold
  ceph: add missing cpu_to_le32() calls when encoding a reconnect capability
  ceph: ceph_pagelist_append might sleep while atomic

 fs/ceph/locks.c      |   75 ++++++++++++++++++++++++++++++++------------------
 fs/ceph/mds_client.c |   65 +++++++++++++++++++++++--------------------
 fs/ceph/super.h      |    9 ++++-
 3 files changed, 90 insertions(+), 59 deletions(-)

-- 
1.7.8.2


