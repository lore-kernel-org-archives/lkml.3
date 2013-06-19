Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934838Ab3FSPNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:13:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16173 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934521Ab3FSPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:13:48 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-72-51c1caaa52ab
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 0/4] Optimizations for memory handling in SMACK
Date: Wed, 19 Jun 2013 17:13:31 +0200
Message-id: <1371654816-20772-1-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t9jQd1Vpw4GGpy4bmpxb9svNouzTW/Y
	LS7vmsNm8aHnEZvF2iN32S3eTlrBbDGv/SWrA7tH35ZVjB5H9y9i8/i8SS6AOYrLJiU1J7Ms
	tUjfLoEr4/fsbYwFX5Urzi3YztTAOFG2i5GTQ0LAROLBjL+sELaYxIV769m6GLk4hASmM0qc
	nv+XBcLpYpK4eGk6C0gVG1DHsSWfGUFsEQFNiWPTITqYBbYxSnS8mMoEkhAWsJfYvnIK2FgW
	AVWJHVOOgMV5BTwkljbdYoJYJy/x9H4f2wRG7gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLz
	czcxgoPimfQOxlUNFocYBTgYlXh4HeYeDBRiTSwrrsw9xCjBwawkwrv0KFCINyWxsiq1KD++
	qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QDI8OCzz1Fwskhx2e0z9y/5NO7
	igq1qTNld/BuuL2/KyU6j1UqY5lk4JS5fw3zdigsiNR2VcqxlTZh2em4YOr1Dxbtc55O1ZtQ
	vtQm1o634TrXH2OpaRyvdDdVcO9oVJN9y+TMfn3vzZoi1rKD305XWTXPWDWf0XPZ+olTtRqS
	RSR39iaF/1iop8RSnJFoqMVcVJwIAIndHogGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,
This patchset focuses on optimizations for memory handling done in internals of
smk_write_rules_list(). It is an update from [1].

The first patch introduces a limit for maximal length of a rule string.  The
second patch optimizes rule string parsing to avoid unnecessary allocations.
The third and the forth introduce kmem_cache to reduce memory wasted on padding
bytes.

The patchset is rebased on smack/next. Additionally the "memleak" patch [2] has
to be applied. This patch conflicts with the this patchset.

Some measurements for time and used memory were prepared.  The test platform
was ARM target. The Smack configuration contains circa 17K rules and 500
labels.  The procedure is following:
1. Boot the target with 'init=/bin/bash' added to cmdline.
2. Mount all needed file systems (procfs and smackfs in principle)
3. Measure SLAB memory with (column Pre expressed in [kiB]):
   # grep SUnreclaim: /proc/meminfo
4. Initialize SMACK and measure time (column Time [sec])
   # time smackctl apply
5. Measure SLAB memory with (column Post expressed in [kiB]):
   # grep SUnreclaim: /proc/meminfo

Each measurement was repeated 5 time to reduce noise.
The column 'Diff' is equal to 'Post' - 'Pre'.
This value is expected to be equal to kernel memory
allocated during the initialization of SMACK.

Result for the reference kernel from smack/next:

Run:|Pre |Post|Diff|Time
.-------------------------
1   |5132|7116|1984|1.162
2   |5148|7024|1876|1.134
3   |5292|7264|1972|1.148
4   |5436|7424|1988|1.156
5   |5364|7276|1912|1.140
.-------------------------
AVG:|    |    |1946|1.148


Results for reference kernel plus memfix patch.

Run:|Pre |Post|Diff|Time
.-------------------------
1   |5056|6388|1332|1.149
2   |5072|6444|1372|1.127
3   |4892|6336|1444|1.131
4   |5468|6740|1272|1.149
5   |5192|6520|1328|1.145
.-------------------------
AVG:|    |    |1349|1.140

Fixing the memleak reduced memeory consumption by 600 KiB.


Results for previous kernel + patch 2. Patch 1 was not tested
because it is only a protection limit.

Run:|Pre |Post|Diff|Time
.-------------------------
1   |5264|6616|1352|1.117
2   |5352|6668|1316|1.115
3   |5400|6752|1352|1.118
4   |5220|6668|1448|1.122
5   |5316|6652|1336|1.101
.-------------------------
AVG:|    |    |1360|1.115

The patch 2 fastened rule loading by 25 ms.


Results for previous kernel + patch 3.

Run:|Pre |Post|Diff|Time
.-------------------------
1   |5212|6432|1220|1.106
2   |5408|6552|1144|1.118
3   |5044|6292|1248|1.107
4   |5232|6428|1196|1.120
5   |5268|6492|1224|1.111
.-------------------------
AVG:|    |    |1206|1.112

Memory consumption was reduced by 154 kiB. The patch reduced
memory used for single rule entity from 32 to 24 bytes.
This gives 8 * 17k = 132 KiB. The value is consistent with
measurements due to high noise.

Results for previous kernel + patch 3.

Run:|Pre |Post|Diff|Time
.-------------------------
1   |5300|6176| 876|1.098
2   |5044|5984| 940|1.086
3   |5504|6436| 932|1.074
4   |5244|6200| 956|1.083
5   |5280|6164| 884|1.088
.-------------------------
AVG:|    |    | 918|1.086

Memory consumption was reduced by 288 kiB. The patch reduced
memory used for single master rule entity from 32 to 16 bytes.
This gives 16 * 17k = 264 KiB. The value is consistent with
measurements due to high noise. Moreover, the initialization
was sped up by 26 ms.

To sum up, all the patches plus the memory fix reduced the amount
of memory for rule-related structures from 1946 kiB to 918 kiB.
Memory requirements were reduced by half.

I hope you find this patchset useful.
All comments are welcome.

Regards,
Tomasz Stanislawski.

Changelog:
v1:
- post 'fix memleak in smk_write_rules_list() as a separate patch'
- prepare performance measurements
- remove stack allocations for a rule string, use kmalloc()

[1] http://en.it-usenet.org/thread/20260/343969/
[2] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg454761.html

Tomasz Stanislawski (4):
  security: smack: limit a length for a rule string in the long format
  security: smack: avoid kmalloc() in smk_parse_long_rule()
  security: smack: add kmem_cache for smack_rule allocations
  security: smack: add kmem_cache for smack_master_list allocations

 security/smack/smack.h     |   10 ++++++
 security/smack/smack_lsm.c |   19 +++++++++-
 security/smack/smackfs.c   |   83 ++++++++++++++++++++++++--------------------
 3 files changed, 74 insertions(+), 38 deletions(-)

-- 
1.7.9.5

