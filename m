Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934149AbaFSRHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:07:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:59927 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894AbaFSRHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:07:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,508,1400050800"; 
   d="scan'208";a="560272642"
Message-ID: <53A3181F.9070005@intel.com>
Date: Thu, 19 Jun 2014 10:04:31 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>, Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-8-git-send-email-qiaowei.ren@intel.com> <20140618100745.GB24419@pd.tnic> <9E0BE1322F2F2246BD820DA9FC397ADE016A3BAA@shsmsx102.ccr.corp.intel.com> <20140619062824.GB22025@pd.tnic> <9E0BE1322F2F2246BD820DA9FC397ADE016A3F75@shsmsx102.ccr.corp.intel.com>
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE016A3F75@shsmsx102.ccr.corp.intel.com>
Content-Type: multipart/mixed;
 boundary="------------020505010703080004050409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020505010703080004050409
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/18/2014 11:53 PM, Ren, Qiaowei wrote:
> On 2014-06-19, Borislav Petkov wrote:
>> On Thu, Jun 19, 2014 at 01:13:48AM +0000, Ren, Qiaowei wrote:
>>> On 2014-06-18, Borislav Petkov wrote:
>>>> On Wed, Jun 18, 2014 at 05:44:13PM +0800, Qiaowei Ren wrote:
>>>>
>>>> This whole insn decoding machinery above looks like adapted from
>>>> arch/x86/lib/insn.c. You should merge it with the generic code in
>>>> insn.c instead of homegrowing it here only for the purposes of MPX.
>>>> And if it doesn't work for your needs, you should should extend
>>>> the generic code to do so.
>>
>>> Petkov, as we discussed on initial version of this patchset, general
>>> insn framework didn't work out well and I have tried to use generic
>>> struct insn, insn_field, etc. for obvious benefits.
>>
>> Let me repeat myself: "And if it doesn't work for your needs, you
>> should extend the generic code to do so."
>>
>> We don't do homegrown almost-copies of generic code.
>> 
> I see. If possible, I will be very happy to use or extend generic
> code. But due to extra overhead caused by MPX, I have to use MPX
> specific decoding to do performance optimization.

Could you please support this position with some data?  I'm a bit
skeptical that instruction decoding is going to be a
performance-critical path.

I also don't see the extra field that you talked about in the previous
thread?  What's the extra field?  I see a 'limit' vs. 'length', but you
don't use 'length' at all, so I think you can use it instead, or at
least union it.

I've taken a quick stab at trying to consolidate things.  I think I may
have screwed up this:

	insn->limit = MAX_MPX_INSN_SIZE - bytes;

Qiaowei, is there anything fundamentally broken with what I've got here?


--------------020505010703080004050409
Content-Type: text/x-patch;
 name="consolidate-instruction-decoding.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="consolidate-instruction-decoding.patch"



---

 b/arch/x86/include/asm/insn.h |    1 
 b/arch/x86/include/asm/mpx.h  |   14 ---
 b/arch/x86/kernel/mpx.c       |  183 ++----------------------------------------
 b/arch/x86/lib/insn.c         |   43 +++++++++
 4 files changed, 56 insertions(+), 185 deletions(-)

diff -puN arch/x86/kernel/mpx.c~consolidate-instruction-decoding arch/x86/kernel/mpx.c
--- a/arch/x86/kernel/mpx.c~consolidate-instruction-decoding	2014-06-19 09:53:53.894441788 -0700
+++ b/arch/x86/kernel/mpx.c	2014-06-19 09:53:53.909442460 -0700
@@ -3,6 +3,7 @@
 #include <linux/prctl.h>
 #include <asm/mpx.h>
 #include <asm/i387.h>
+#include <asm/insn.h>
 #include <asm/fpu-internal.h>
 
 /*
@@ -59,7 +60,7 @@ int mpx_unregister(struct task_struct *t
 }
 
 typedef enum {REG_TYPE_RM, REG_TYPE_INDEX, REG_TYPE_BASE} reg_type_t;
-static unsigned long get_reg(struct mpx_insn *insn, struct pt_regs *regs,
+static unsigned long get_reg(struct insn *insn, struct pt_regs *regs,
 			     reg_type_t type)
 {
 	int regno = 0;
@@ -118,7 +119,7 @@ static unsigned long get_reg(struct mpx_
  * for rm=3 returning the content of the rm reg
  * for rm!=3 calculates the address using SIB and Disp
  */
-static unsigned long get_addr_ref(struct mpx_insn *insn, struct pt_regs *regs)
+static unsigned long get_addr_ref(struct insn *insn, struct pt_regs *regs)
 {
 	unsigned long addr;
 	unsigned long base;
@@ -142,182 +143,22 @@ static unsigned long get_addr_ref(struct
 	return addr;
 }
 
-/* Verify next sizeof(t) bytes can be on the same instruction */
-#define validate_next(t, insn, n)	\
-	((insn)->next_byte + sizeof(t) + n - (insn)->kaddr <= (insn)->limit)
-
-#define __get_next(t, insn)		\
-({					\
-	t r = *(t *)insn->next_byte;	\
-	insn->next_byte += sizeof(t);	\
-	r;				\
-})
-
-#define __peek_next(t, insn)		\
-({					\
-	t r = *(t *)insn->next_byte;	\
-	r;				\
-})
-
-#define get_next(t, insn)		\
-({					\
-	if (unlikely(!validate_next(t, insn, 0)))	\
-		goto err_out;		\
-	__get_next(t, insn);		\
-})
-
-#define peek_next(t, insn)		\
-({					\
-	if (unlikely(!validate_next(t, insn, 0)))	\
-		goto err_out;		\
-	__peek_next(t, insn);		\
-})
-
-static void mpx_insn_get_prefixes(struct mpx_insn *insn)
-{
-	unsigned char b;
-
-	/* Decode legacy prefix and REX prefix */
-	b = peek_next(unsigned char, insn);
-	while (b != 0x0f) {
-		/*
-		 * look for a rex prefix
-		 * a REX prefix cannot be followed by a legacy prefix.
-		 */
-		if (insn->x86_64 && ((b&0xf0) == 0x40)) {
-			insn->rex_prefix.value = b;
-			insn->rex_prefix.nbytes = 1;
-			insn->next_byte++;
-			break;
-		}
-
-		/* check the other legacy prefixes */
-		switch (b) {
-		case 0xf2:
-		case 0xf3:
-		case 0xf0:
-		case 0x64:
-		case 0x65:
-		case 0x2e:
-		case 0x3e:
-		case 0x26:
-		case 0x36:
-		case 0x66:
-		case 0x67:
-			insn->next_byte++;
-			break;
-		default: /* everything else is garbage */
-			goto err_out;
-		}
-		b = peek_next(unsigned char, insn);
-	}
-
-err_out:
-	return;
-}
-
-static void mpx_insn_get_modrm(struct mpx_insn *insn)
-{
-	insn->modrm.value = get_next(unsigned char, insn);
-	insn->modrm.nbytes = 1;
-
-err_out:
-	return;
-}
-
-static void mpx_insn_get_sib(struct mpx_insn *insn)
-{
-	unsigned char modrm = (unsigned char)insn->modrm.value;
-
-	if (X86_MODRM_MOD(modrm) != 3 && X86_MODRM_RM(modrm) == 4) {
-		insn->sib.value = get_next(unsigned char, insn);
-		insn->sib.nbytes = 1;
-	}
-
-err_out:
-	return;
-}
-
-static void mpx_insn_get_displacement(struct mpx_insn *insn)
-{
-	unsigned char mod, rm, base;
-
-	/*
-	 * Interpreting the modrm byte:
-	 * mod = 00 - no displacement fields (exceptions below)
-	 * mod = 01 - 1-byte displacement field
-	 * mod = 10 - displacement field is 4 bytes
-	 * mod = 11 - no memory operand
-	 *
-	 * mod != 11, r/m = 100 - SIB byte exists
-	 * mod = 00, SIB base = 101 - displacement field is 4 bytes
-	 * mod = 00, r/m = 101 - rip-relative addressing, displacement
-	 *	field is 4 bytes
-	 */
-	mod = X86_MODRM_MOD(insn->modrm.value);
-	rm = X86_MODRM_RM(insn->modrm.value);
-	base = X86_SIB_BASE(insn->sib.value);
-	if (mod == 3)
-		return;
-	if (mod == 1) {
-		insn->displacement.value = get_next(unsigned char, insn);
-		insn->displacement.nbytes = 1;
-	} else if ((mod == 0 && rm == 5) || mod == 2 ||
-			(mod == 0 && base == 5)) {
-		insn->displacement.value = get_next(int, insn);
-		insn->displacement.nbytes = 4;
-	}
-
-err_out:
-	return;
-}
-
-static void mpx_insn_init(struct mpx_insn *insn, struct pt_regs *regs)
-{
-	unsigned char buf[MAX_MPX_INSN_SIZE];
-	int bytes;
-
-	memset(insn, 0, sizeof(*insn));
-
-	bytes = copy_from_user(buf, (void __user *)regs->ip, MAX_MPX_INSN_SIZE);
-	insn->limit = MAX_MPX_INSN_SIZE - bytes;
-	insn->kaddr = buf;
-	insn->next_byte = buf;
-
-	/*
-	 * In 64-bit Mode, all Intel MPX instructions use 64-bit
-	 * operands for bounds and 64 bit addressing, i.e. REX.W &
-	 * 67H have no effect on data or address size.
-	 *
-	 * In compatibility and legacy modes (including 16-bit code
-	 * segments, real and virtual 8086 modes) all Intel MPX
-	 * instructions use 32-bit operands for bounds and 32 bit
-	 * addressing.
-	 */
-#ifdef CONFIG_X86_64
-	insn->x86_64 = 1;
-	insn->addr_bytes = 8;
-#else
-	insn->x86_64 = 0;
-	insn->addr_bytes = 4;
-#endif
-}
-
-static unsigned long mpx_insn_decode(struct mpx_insn *insn,
+static unsigned long insn_decode(struct insn *insn,
 				     struct pt_regs *regs)
 {
-	mpx_insn_init(insn, regs);
+	int is_64bit = IS_ENABLED(CONFIG_X86_64) && !test_thread_flag(TIF_IA32);
 
+	insn_init(insn, regs, is_64bit);
 	/*
 	 * In this case, we only need decode bndcl/bndcn/bndcu,
 	 * so we can use private diassembly interfaces to get
 	 * prefixes, modrm, sib, displacement, etc..
 	 */
-	mpx_insn_get_prefixes(insn);
+	insn_get_prefixes(insn);
 	insn->next_byte += 2; /* ignore opcode */
-	mpx_insn_get_modrm(insn);
-	mpx_insn_get_sib(insn);
-	mpx_insn_get_displacement(insn);
+	insn_get_modrm(insn);
+	insn_get_sib(insn);
+	insn_get_displacement(insn);
 
 	return get_addr_ref(insn, regs);
 }
@@ -390,11 +231,11 @@ int do_mpx_bt_fault(struct xsave_struct
 void do_mpx_bounds(struct pt_regs *regs, siginfo_t *info,
 		struct xsave_struct *xsave_buf)
 {
-	struct mpx_insn insn;
+	struct insn insn;
 	uint8_t bndregno;
 	unsigned long addr_vio;
 
-	addr_vio = mpx_insn_decode(&insn, regs);
+	addr_vio = insn_decode(&insn, regs);
 
 	bndregno = X86_MODRM_REG(insn.modrm.value);
 	if (bndregno > 3)
diff -puN arch/x86/include/asm/mpx.h~consolidate-instruction-decoding arch/x86/include/asm/mpx.h
--- a/arch/x86/include/asm/mpx.h~consolidate-instruction-decoding	2014-06-19 09:53:53.895441833 -0700
+++ b/arch/x86/include/asm/mpx.h	2014-06-19 09:53:53.909442460 -0700
@@ -53,20 +53,6 @@
 #define MPX_BNDCFG_ENABLE_FLAG	0x1
 #define MPX_BD_ENTRY_VALID_FLAG	0x1
 
-struct mpx_insn {
-	struct insn_field rex_prefix;	/* REX prefix */
-	struct insn_field modrm;
-	struct insn_field sib;
-	struct insn_field displacement;
-
-	unsigned char addr_bytes;	/* effective address size */
-	unsigned char limit;
-	unsigned char x86_64;
-
-	const unsigned char *kaddr;	/* kernel address of insn to analyze */
-	const unsigned char *next_byte;
-};
-
 #define MAX_MPX_INSN_SIZE	15
 
 unsigned long mpx_mmap(unsigned long len);
diff -puN arch/x86/include/asm/insn.h~consolidate-instruction-decoding arch/x86/include/asm/insn.h
--- a/arch/x86/include/asm/insn.h~consolidate-instruction-decoding	2014-06-19 09:53:53.897441922 -0700
+++ b/arch/x86/include/asm/insn.h	2014-06-19 09:53:53.910442505 -0700
@@ -98,6 +98,7 @@ struct insn {
 
 extern void insn_init(struct insn *insn, const void *kaddr, int x86_64);
 extern void insn_get_prefixes(struct insn *insn);
+extern void mpx_insn_get_prefixes(struct insn *insn);
 extern void insn_get_opcode(struct insn *insn);
 extern void insn_get_modrm(struct insn *insn);
 extern void insn_get_sib(struct insn *insn);
diff -puN arch/x86/lib/insn.c~consolidate-instruction-decoding arch/x86/lib/insn.c
--- a/arch/x86/lib/insn.c~consolidate-instruction-decoding	2014-06-19 09:53:53.899442011 -0700
+++ b/arch/x86/lib/insn.c	2014-06-19 09:53:53.910442505 -0700
@@ -63,6 +63,49 @@ void insn_init(struct insn *insn, const
 		insn->addr_bytes = 4;
 }
 
+void mpx_insn_get_prefixes(struct insn *insn)
+{
+	unsigned char b;
+
+	/* Decode legacy prefix and REX prefix */
+	b = peek_next(unsigned char, insn);
+	while (b != 0x0f) {
+		/*
+		 * look for a rex prefix
+		 * a REX prefix cannot be followed by a legacy prefix.
+		 */
+		if (insn->x86_64 && ((b&0xf0) == 0x40)) {
+			insn->prefixes.value = b;
+			insn->prefixes.nbytes = 1;
+			insn->next_byte++;
+			break;
+		}
+
+		/* check the other legacy prefixes */
+		switch (b) {
+		case 0xf2:
+		case 0xf3:
+		case 0xf0:
+		case 0x64:
+		case 0x65:
+		case 0x2e:
+		case 0x3e:
+		case 0x26:
+		case 0x36:
+		case 0x66:
+		case 0x67:
+			insn->next_byte++;
+			break;
+		default: /* everything else is garbage */
+			goto err_out;
+		}
+		b = peek_next(unsigned char, insn);
+	}
+
+err_out:
+	return;
+}
+
 /**
  * insn_get_prefixes - scan x86 instruction prefix bytes
  * @insn:	&struct insn containing instruction
_

--------------020505010703080004050409--
