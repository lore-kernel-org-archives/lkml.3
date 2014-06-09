Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbaFIMJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 08:09:46 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:32846 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbaFIMJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:09:44 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH v3 0/3] Add Qualcomm crypto driver
Date: Mon,  9 Jun 2014 15:08:37 +0300
Message-Id: <1402315720-5042-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the third version of the crypto driver.

Changes since v2:

- reworked crypto_enqueue/dequeue_request mechanism. The queue
  length has been changed to one to reflect the hardware
  capabilities
- the workqueue has been deleted and replaced by new queue function
- few not functional changes like making some variables const
- fixed one issue in SG helper related to SG table manipulation
- added fallback for algorithms/modes unsupported by the hardware
- patches 1 to 6 are squashed in one i.e 1/3
- patches 7 and 8 are squashed in one i.e 2/3

regards,
Stan

---------------------------------------------------------------------
Here is the second version of the patch set. This time tagged
as an RFC to avoid confusions. The driver is splitted by files
and is buildable at the last patch. When the review has finished
1/9 to 7/9 could be squashed in one patch.

Any comments appreciated!

Changes since v1:

core
 - added MODULE_DEVICE_TABLE
 - reorganise includes
 - kernel doc comments
 - fix probe error path, forgot to destroy workqueue
 - rework clocks and kill loops for enabling
 - restructure the interfaces between core part of the driver
   and crypto type algorithms. Now struct qce_algo_ops has
   .unregister_algs operation and it is implemented by every
   algorithm type (unregister_algs was common in v1).
   Also async_req_queue/done are now part of core structure
   qce_device

regs-v5
 - use GENMASK and include bitops.h

dma-sg helpers
 - do not check !IS_ERR on error path
 - various fixes as per review comments
 - reorganise includes
 - return error on qce_dma_terminate_all

ablkcipher
 - use queue and done callbacks from struct qce_device
 - reorganise includes
 - kernel doc notation

sha-hmac
 - use queue and done callbacks from struct qce_device
 - make byte_count __be32
 - kernel doc notation
 - make rctx flags member unsigned long
 - cleanup qce_ahash_update function
 - make const * input args of qce_import_common

common
 - rename bits/masks to use _SHIFT suffix
 - reorganise includes and add qce_get_version function
 - make rctx flags unsigned long
 - move blocksize boundary check on function begging and
   clear BYTECOUNT registers on first processing block

This driver is based on Codeaurora's driver found at [1]

[1] https://www.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/drivers/crypto/msm?h=msm-3.10

Stanimir Varbanov (3):
  crypto: qce: Qualcomm crypto engine driver
  crypto: qce: Build Qualcomm crypto driver
  ARM: DT: qcom: Add Qualcomm crypto driver binding document

 .../devicetree/bindings/crypto/qcom-qce.txt        |   25 +
 drivers/crypto/Kconfig                             |   15 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/qce/Makefile                        |    6 +
 drivers/crypto/qce/ablkcipher.c                    |  431 ++++++++++++++
 drivers/crypto/qce/cipher.h                        |   68 +++
 drivers/crypto/qce/common.c                        |  435 +++++++++++++++
 drivers/crypto/qce/common.h                        |  102 ++++
 drivers/crypto/qce/core.c                          |  286 ++++++++++
 drivers/crypto/qce/core.h                          |   68 +++
 drivers/crypto/qce/dma.c                           |  186 ++++++
 drivers/crypto/qce/dma.h                           |   58 ++
 drivers/crypto/qce/regs-v5.h                       |  334 +++++++++++
 drivers/crypto/qce/sha.c                           |  588 ++++++++++++++++++++
 drivers/crypto/qce/sha.h                           |   81 +++
 15 files changed, 2684 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.txt
 create mode 100644 drivers/crypto/qce/Makefile
 create mode 100644 drivers/crypto/qce/ablkcipher.c
 create mode 100644 drivers/crypto/qce/cipher.h
 create mode 100644 drivers/crypto/qce/common.c
 create mode 100644 drivers/crypto/qce/common.h
 create mode 100644 drivers/crypto/qce/core.c
 create mode 100644 drivers/crypto/qce/core.h
 create mode 100644 drivers/crypto/qce/dma.c
 create mode 100644 drivers/crypto/qce/dma.h
 create mode 100644 drivers/crypto/qce/regs-v5.h
 create mode 100644 drivers/crypto/qce/sha.c
 create mode 100644 drivers/crypto/qce/sha.h

