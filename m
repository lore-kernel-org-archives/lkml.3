Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbaGAUOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:14:08 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37134 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbaGAUOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:14:05 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
X-Google-Original-From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 0/3] ima: use asynchronous hash API for hash calculation
Date: Tue,  1 Jul 2014 23:12:48 +0300
Message-Id: <cover.1404245510.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on the IMA policy, it might require to measure huge amount of files.
It may be very important to speedup hash calculation or to reduce (bettery)
energy required to do it. Currently IMA uses synchronous hash API (shash)
which is CPU based. CPU based hash calculation is very CPU intensive and on the
battery powered device will be also high energy consuming.

Many platforms provide cryptographic acceleration modules which allow speedup
and/or reduce energy consumption, and provide asynchronous way to calculate
hashes. Defacto way to implement drivers for such accelerators is using
asynchronous hash API (ahash).

The first patch adds use of ahash API to IMA. Performance of using HW
acceleration depends very much on amount of data to hash and it depends
on particular HW. It is usually inefficient for small data due to HW
initialization overhead. In order to make it possible to optimize performance
for particular system, the patch provides kernel parameter
'ima_ahash=<min_file_size>', which allows to specify optimal file size
when start using ahash. By default ahash is disabled until non-zero value
with 'ima_ahash=' is provided.

Second patch introduces multi-page buffers which makes HW acceleration more
efficient. It extends 'ima_ahash' kernel parameter to specify buffer size:
'ima_ahash=<min_file_size>[,<bufsize>]'

Third patch introduces double-buffering which allows to readahead next portion
of data for hashing while calculating the hash.

Changes to v1:
- ima_ahash_size and ima_ahash_bufsize were combined as ima_ahash
- ahash pre-allocation moved out from __init code to be able to use
  ahash crypto modules. Ahash allocated once on the first use.
- hash calculation falls back to sahsh if ahash allocation/calculation fails
- complex initialization separated from variable declaration
- improved comments

- Dmitry


Dmitry Kasatkin (3):
  ima: use ahash API for file hash calculation
  ima: introduce multi-page collect buffers
  ima: provide double buffering for hash calculation

 Documentation/kernel-parameters.txt |   6 +
 security/integrity/ima/ima_crypto.c | 287 +++++++++++++++++++++++++++++++++++-
 2 files changed, 290 insertions(+), 3 deletions(-)

-- 
1.9.1

