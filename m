Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaIBUVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:21:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:36055 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaIBUVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:21:31 -0400
Date: Tue, 2 Sep 2014 22:21:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: Tree for Aug 23
Message-ID: <20140902202126.GA3190@worktop.ger.corp.intel.com>
References: <20140823080422.7895575c@canb.auug.org.au>
 <20140825045741.GA29723@roeck-us.net>
 <20140901155804.GT27892@worktop.ger.corp.intel.com>
 <5404A2F2.3090908@roeck-us.net>
 <20140901190438.GB5806@worktop.ger.corp.intel.com>
 <20140902094016.GD31157@worktop.ger.corp.intel.com>
 <20140902095553.GE31157@worktop.ger.corp.intel.com>
 <20140902190445.GB8829@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902190445.GB8829@roeck-us.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 12:04:45PM -0700, Guenter Roeck wrote:

> I provided qemu images and instructions as follows.
> 	http://server.roeck-us.net/qemu/mipsel/		MIPS 32 bit, little endian
> 	http://server.roeck-us.net/qemu/mips64el/	MIPS 64 bit, little endian
> 
> Let me know if you also need big endian images.

Thanks! Does the below work? It appears to work for the mips64 build I did.
I'll send a proper patch tomorrow; sleep time :-)

---
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index e18741e..869efe7 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -441,3 +441,6 @@ CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC16=m
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_CPU_MIPS64_R1=y
+CONFIG_64BIT=y
diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 476fe3b..f3ee721 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -93,7 +93,7 @@ static __inline__ int atomic_##op##_return(int i, atomic_t * v)			\
 		"	" #asm_op " %0, %1, %3				\n"	\
 		"	sc	%0, %2					\n"	\
 		"	beqzl	%0, 1b					\n"	\
-		"	addu	%0, %1, %3				\n"	\
+		"	" #asm_op " %0, %1, %3				\n"	\
 		"	.set	mips0					\n"	\
 		: "=&r" (result), "=&r" (temp), "+m" (v->counter)		\
 		: "Ir" (i));							\
@@ -111,7 +111,7 @@ static __inline__ int atomic_##op##_return(int i, atomic_t * v)			\
 			: "Ir" (i));						\
 		} while (unlikely(!result));					\
 										\
-		result = temp + i;						\
+		result = temp; result c_op i;					\
 	} else {								\
 		unsigned long flags;						\
 										\
@@ -387,7 +387,7 @@ static __inline__ long atomic64_##op##_return(long i, atomic64_t * v)		\
 			: "memory");						\
 		} while (unlikely(!result));					\
 										\
-		result = temp + i;						\
+		result = temp; result c_op i;					\
 	} else {								\
 		unsigned long flags;						\
 										\

