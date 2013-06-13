Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3FMP3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:29:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34273 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3FMP32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:29:28 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-47-51b9e55732e0
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 0/5] Optimizations for memory handling in smk_write_rules_list()
Date: Thu, 13 Jun 2013 17:29:07 +0200
Message-id: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t9jAd3wpzsDDbZt4rK4t+0Xm8XZpjfs
	Fpd3zWGz+NDziM1i7ZG77BZvJ61gtpjX/pLVgd2jb8sqRo+j+xexeXzeJBfAHMVlk5Kak1mW
	WqRvl8CVMam/l7Hgv0TFrf+8DYwTRboYOTgkBEwkNn0r6WLkBDLFJC7cW8/WxcjFISSwiFFi
	4pUNjBBOF5PErcM72UCq2IAaji35zAhiiwhoShybDtHBLLCNUaLjxVQmkISwgJ/EwgmnwIpY
	BFQlZu+eC9bMK+Ah0T7lIDPEOnmJp/f72CYwci9gZFjFKJpakFxQnJSea6hXnJhbXJqXrpec
	n7uJERwQz6R2MK5ssDjEKMDBqMTDm3BhZ6AQa2JZcWXuIUYJDmYlEV71h0Ah3pTEyqrUovz4
	otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjL3/qn4Jhu/4f6FVx3hlyKfg
	1OamFoV9Pq2NFsxH977+4PJK+5i0guAF/3Bjn+enVe7rXW1juNo9QaXuVrDYJBPn6Qk8NUGz
	DP7xSiu6TIzaUxVl8OuI69pZa1fOl/2iw3g5J+Gh+p5HR/2VXOZYmSt/MXojLzi1+aCK6wWV
	oBNLVd8YHD0upsRSnJFoqMVcVJwIAA065+wEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,
This patchset focuses on optimizations for memory handling done in
smk_write_rules_list().  Basically, all the patches try to avoid calling
kmalloc().  I expect that there might be some controversy about these patches.

The first patch introduces a limit for length if SMACK rules in 'long' format.
The limit was chosen to handle two long labels (SMK_LONGLABEL) plus access
flags plus two separators.  Passing a longer rule is likely an error due to too
long labels or having a rule string that contains a ridiculous amount of
whitespaces.  Introducing the limit helps to protect the kernel if userspace
(maybe privileged but still userspace) passed too large write(). Calling
kmalloc() for a large size wull trigger a significant number of page reclaim
actions or even OOM.  Moreover, such an allocation is very likely to fail and
it should be avoided. Calling vmalloc() would be a much safer idea.  Anyway,
the buffer is valid only during smk_write_rules_list() therefore allocating a
buffer on stack simplifies memory management.

The second patch simplifies memory management in smk_parse_long_rule() and
speeds up parsing.

The third patch fixes a potential memory leak in smk_write_rules_list().  I was
not able to find any reference to smack_parsed_rule after the function is
finished. Notice that smk_user_access() does not use dynamic any allocation for
smack_parsed_rule.  I kindly ask you to review the patch.

The last two patches uses kmem_cache to avoid wasting memory for padding bytes
for the most frequently allocated structures in SMACK.

The patchset provides a small but observable performance improvement of SMACK
initialization phase.  The results below were collected for 17K rules and 500
labels using command 'time smackctl apply'.

        |  Run1 |  Run2 |  Run3 |  Run4 |  Run5 |  Avg  | Gain [ms]
--------------------------------------------------------------
Ref     | 1.177 | 1.174 | 1.177 | 1.179 | 1.171 | 1.176 | 0
patch1  | 1.165 | 1.177 | 1.178 | 1.167 | 1.175 | 1.172 | 3
patch2  | 1.145 | 1.142 | 1.140 | 1.139 | 1.137 | 1.141 | 35
patch3  | 1.117 | 1.128 | 1.126 | 1.129 | 1.124 | 1.125 | 51
patch4  | 1.097 | 1.120 | 1.119 | 1.112 | 1.120 | 1.114 | 62
patch5  | 1.092 | 1.102 | 1.090 | 1.108 | 1.091 | 1.097 | 79

Every patch introduces a tiny bit of speed improvement.  Total gain is 7%.
It will increase to 15% if the patch for label hashing [1] is applied.

I hope you find this patchset useful.
Regards,
Tomasz Stanislawski

References:
[1] http://thread.gmane.org/gmane.linux.kernel.lsm/19609


Tomasz Stanislawski (5):
  security: smack: avoid kmalloc allocations while loading a rule
    string
  security: smack: avoid kmalloc() in smk_parse_long_rule()
  security: smack: fix memleak in smk_write_rules_list()
  security: smack: add kmem_cache for smack_rule allocations
  security: smack: add kmem_cache for smack_master_list allocations

 security/smack/smack.h     |   10 ++++
 security/smack/smack_lsm.c |   19 ++++++-
 security/smack/smackfs.c   |  122 +++++++++++++++++++-------------------------
 3 files changed, 80 insertions(+), 71 deletions(-)

-- 
1.7.9.5

