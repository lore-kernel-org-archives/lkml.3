Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161722AbaDPPLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:11:06 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45499 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161528AbaDPPK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:10:59 -0400
Message-ID: <534E9D80.9050801@mm-sol.com>
Date: Wed, 16 Apr 2014 18:10:56 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Stanimir Varbanov <svarbanov@mm-sol.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>, linux-arm-msm@vger.kernel.org,
        Mona Hossain <mhossain@codeaurora.org>,
        Hariprasad Dhalinarasimha <hnamgund@codeaurora.org>,
        Zhen Kong <zkong@codeaurora.org>,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/9] Add Qualcomm crypto driver
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
In-Reply-To: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert, crypto folks

I would like to know your opinions on the state of this driver. How far
it is from the others crypto drivers in kernel. If you have some
comments, criticisms etc. I will be glad to hear them and correct the
potential issues.

Thanks for your time.

regards,
Stan

On 04/14/2014 03:48 PM, Stanimir Varbanov wrote:
> Hi,
> 
> Here is the second version of the patch set. This time tagged
> as an RFC to avoid confusions. The driver is splitted by files
> and is buildable at the last patch. When the review has finished
> 1/9 to 7/9 could be squashed in one patch.
> 
> Any comments appreciated!
> 
> Changes since v1:
> 
> core
>  - added MODULE_DEVICE_TABLE
>  - reorganise includes
>  - kernel doc comments
>  - fix probe error path, forgot to destroy workqueue
>  - rework clocks and kill loops for enabling
>  - restructure the interfaces between core part of the driver
>    and crypto type algorithms. Now struct qce_algo_ops has
>    .unregister_algs operation and it is implemented by every
>    algorithm type (unregister_algs was common in v1).
>    Also async_req_queue/done are now part of core structure
>    qce_device
> 
> regs-v5
>  - use GENMASK and include bitops.h
> 
> dma-sg helpers
>  - do not check !IS_ERR on error path
>  - various fixes as per review comments
>  - reorganise includes
>  - return error on qce_dma_terminate_all
> 
> ablkcipher
>  - use queue and done callbacks from struct qce_device
>  - reorganise includes
>  - kernel doc notation
> 
> sha-hmac
>  - use queue and done callbacks from struct qce_device
>  - make byte_count __be32
>  - kernel doc notation
>  - make rctx flags member unsigned long
>  - cleanup qce_ahash_update function
>  - make const * input args of qce_import_common
> 
> common
>  - rename bits/masks to use _SHIFT suffix
>  - reorganise includes and add qce_get_version function
>  - make rctx flags unsigned long
>  - move blocksize boundary check on function begging and
>    clear BYTECOUNT registers on first processing block
> 
> This driver is based on Codeaurora's driver found at [1]
> 
> regards,
> Stan
> 
> [1] https://www.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/drivers
> /crypto/msm?h=msm-3.10
> ------------------------------------------------------------
> v1.
> 
> The following patch set implements support for Qualcomm
> crypto hardware accelerator driver. It registers itself
> to the crypto subsystem and adds the following operations
> for encryption/decription - AES with ECB CBC CTR XTS modes,
> DES with ECB CBC modes, and 3DES ECB CBC modes.
> For hashing and MAC it adds support for sha1 sha256,
> hmac(sha1) hmac(sha256).
> 
> The version of the driver is reworked by me and it is based
> on Codeaurora's qcrypto driver. The proposed version has many
> coding style fixes, re-factored files, separated by
> functionality. I wanted to make the driver more readable and
> easier for review, hope I done well. I'll appreciate any review
> comments which will help me to make this code clear and ready
> for mainline kernel.
> 
> Stanimir Varbanov (9):
>   crypto: qce: Add core driver implementation
>   crypto: qce: Add register defines
>   crypto: qce: Add dma and sg helpers
>   crypto: qce: Add ablkcipher algorithms
>   crypto: qce: Adds sha and hmac transforms
>   crypto: qce: Adds infrastructure to setup the crypto block
>   crypto: qce: Adds Makefile to build the driver
>   crypto: qce: Build Qualcomm qce driver
>   ARM: DT: qcom: Add Qualcomm crypto driver binding document
> 
>  .../devicetree/bindings/crypto/qcom-qce.txt        |  25 +
>  drivers/crypto/Kconfig                             |  10 +
>  drivers/crypto/Makefile                            |   1 +
>  drivers/crypto/qce/Makefile                        |   6 +
>  drivers/crypto/qce/ablkcipher.c                    | 403 ++++++++++++++
>  drivers/crypto/qce/cipher.h                        |  67 +++
>  drivers/crypto/qce/common.c                        | 438 +++++++++++++++
>  drivers/crypto/qce/common.h                        | 104 ++++
>  drivers/crypto/qce/core.c                          | 295 ++++++++++
>  drivers/crypto/qce/core.h                          |  73 +++
>  drivers/crypto/qce/dma.c                           | 188 +++++++
>  drivers/crypto/qce/dma.h                           |  58 ++
>  drivers/crypto/qce/regs-v5.h                       | 331 ++++++++++++
>  drivers/crypto/qce/sha.c                           | 591 +++++++++++++++++++++
>  drivers/crypto/qce/sha.h                           |  81 +++
>  15 files changed, 2671 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.txt
>  create mode 100644 drivers/crypto/qce/Makefile
>  create mode 100644 drivers/crypto/qce/ablkcipher.c
>  create mode 100644 drivers/crypto/qce/cipher.h
>  create mode 100644 drivers/crypto/qce/common.c
>  create mode 100644 drivers/crypto/qce/common.h
>  create mode 100644 drivers/crypto/qce/core.c
>  create mode 100644 drivers/crypto/qce/core.h
>  create mode 100644 drivers/crypto/qce/dma.c
>  create mode 100644 drivers/crypto/qce/dma.h
>  create mode 100644 drivers/crypto/qce/regs-v5.h
>  create mode 100644 drivers/crypto/qce/sha.c
>  create mode 100644 drivers/crypto/qce/sha.h
> 


-- 
regards,
Stan
