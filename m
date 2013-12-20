Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab3LTKKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:10:05 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56037 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab3LTKJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:09:40 -0500
Message-ID: <52B4169D.7000305@linux.vnet.ibm.com>
Date: Fri, 20 Dec 2013 15:36:21 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: mikey@neuling.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        eranian@google.com, linuxppc-dev@ozlabs.org, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH V4 07/10] powerpc, lib: Add new branch instruction analysis
 support functions
References: <20131209062146.6D5C12C00BF@ozlabs.org> <52A6B028.3090001@linux.vnet.ibm.com>
In-Reply-To: <52A6B028.3090001@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122010-9264-0000-0000-0000052797EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 11:39 AM, Anshuman Khandual wrote:
> On 12/09/2013 11:51 AM, Michael Ellerman wrote:
>> On Wed, 2013-04-12 at 10:32:39 UTC, Anshuman Khandual wrote:
>>> Generic powerpc branch instruction analysis support added in the code
>>> patching library which will help the subsequent patch on SW based
>>> filtering of branch records in perf. This patch also converts and
>>> exports some of the existing local static functions through the header
>>> file to be used else where.
>>>
>>> diff --git a/arch/powerpc/include/asm/code-patching.h b/arch/powerpc/include/asm/code-patching.h
>>> index a6f8c7a..8bab417 100644
>>> --- a/arch/powerpc/include/asm/code-patching.h
>>> +++ b/arch/powerpc/include/asm/code-patching.h
>>> @@ -22,6 +22,36 @@
>>>  #define BRANCH_SET_LINK	0x1
>>>  #define BRANCH_ABSOLUTE	0x2
>>>  
>>> +#define XL_FORM_LR  0x4C000020
>>> +#define XL_FORM_CTR 0x4C000420
>>> +#define XL_FORM_TAR 0x4C000460
>>> +
>>> +#define BO_ALWAYS    0x02800000
>>> +#define BO_CTR       0x02000000
>>> +#define BO_CRBI_OFF  0x00800000
>>> +#define BO_CRBI_ON   0x01800000
>>> +#define BO_CRBI_HINT 0x00400000
>>> +
>>> +/* Forms of branch instruction */
>>> +int instr_is_branch_iform(unsigned int instr);
>>> +int instr_is_branch_bform(unsigned int instr);
>>> +int instr_is_branch_xlform(unsigned int instr);
>>> +
>>> +/* Classification of XL-form instruction */
>>> +int is_xlform_lr(unsigned int instr);
>>> +int is_xlform_ctr(unsigned int instr);
>>> +int is_xlform_tar(unsigned int instr);
>>> +
>>> +/* Branch instruction is a call */
>>> +int is_branch_link_set(unsigned int instr);
>>> +
>>> +/* BO field analysis (B-form or XL-form) */
>>> +int is_bo_always(unsigned int instr);
>>> +int is_bo_ctr(unsigned int instr);
>>> +int is_bo_crbi_off(unsigned int instr);
>>> +int is_bo_crbi_on(unsigned int instr);
>>> +int is_bo_crbi_hint(unsigned int instr);
>>
>>
>> I think this is the wrong API.
>>
>> We end up with all these micro checks, which don't actually encapsulate much,
>> and don't implement the logic perf needs. If we had another user for this level
>> of detail then it might make sense, but for a single user I think we're better
>> off just implementing the semantics it wants.
>>
> 
> Having a comprehensive list of branch instruction analysis APIs which some other
> user can also use in the future does not make it wrong. Being more elaborate and
> detailed makes this one a better choice than the API you have suggested below.
> 
>> So that would be something more like:
>>
>> bool instr_is_return_branch(unsigned int instr);
>> bool instr_is_conditional_branch(unsigned int instr);
>> bool instr_is_func_call(unsigned int instr);
>> bool instr_is_indirect_func_call(unsigned int instr);
>>
>>
>> These would then encapsulate something like the logic in your 8/10 patch. You
>> can hopefully also optimise the checking logic in each routine because you know
>> the exact semantics you're implementing.

Any ways, here is the patch which is will supersede the present patch for adding
required library functions. Hope this works.

commit 9d9f11a6b778b51732aaa0e7c9dea4be3385df56
Author: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Date:   Fri Dec 20 13:46:15 2013 +0530

    powerpc, lib: Add new branch analysis support functions
    
    Generic powerpc branch analysis support added in the code patching
    library which will help the subsequent patch on SW based filtering
    of branch records in perf.
    
    Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>

diff --git a/arch/powerpc/include/asm/code-patching.h b/arch/powerpc/include/asm/code-patching.h
index a6f8c7a..15700b5 100644
--- a/arch/powerpc/include/asm/code-patching.h
+++ b/arch/powerpc/include/asm/code-patching.h
@@ -22,6 +22,16 @@
 #define BRANCH_SET_LINK	0x1
 #define BRANCH_ABSOLUTE	0x2
 
+#define XL_FORM_LR  0x4C000020
+#define XL_FORM_CTR 0x4C000420
+#define XL_FORM_TAR 0x4C000460
+
+#define BO_ALWAYS    0x02800000
+#define BO_CTR       0x02000000
+#define BO_CRBI_OFF  0x00800000
+#define BO_CRBI_ON   0x01800000
+#define BO_CRBI_HINT 0x00400000
+
 unsigned int create_branch(const unsigned int *addr,
 			   unsigned long target, int flags);
 unsigned int create_cond_branch(const unsigned int *addr,
@@ -49,4 +59,10 @@ static inline unsigned long ppc_function_entry(void *func)
 #endif
 }
 
+/* Perf branch filters */
+bool instr_is_return_branch(unsigned int instr);
+bool instr_is_conditional_branch(unsigned int instr);
+bool instr_is_func_call(unsigned int instr);
+bool instr_is_indirect_func_call(unsigned int instr);
+
 #endif /* _ASM_POWERPC_CODE_PATCHING_H */
diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 17e5b23..ad39c58 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -77,6 +77,7 @@ static unsigned int branch_opcode(unsigned int instr)
 	return (instr >> 26) & 0x3F;
 }
 
+/* Forms of branch instruction */
 static int instr_is_branch_iform(unsigned int instr)
 {
 	return branch_opcode(instr) == 18;
@@ -87,6 +88,140 @@ static int instr_is_branch_bform(unsigned int instr)
 	return branch_opcode(instr) == 16;
 }
 
+static int instr_is_branch_xlform(unsigned int instr)
+{
+	return branch_opcode(instr) == 19;
+}
+
+/* Classification of XL-form instruction */
+static int is_xlform_lr(unsigned int instr)
+{
+	return (instr & XL_FORM_LR) == XL_FORM_LR;
+}
+
+static int is_xlform_ctr(unsigned int instr)
+{
+	return (instr & XL_FORM_CTR) == XL_FORM_CTR;
+}
+
+static int is_xlform_tar(unsigned int instr)
+{
+	return (instr & XL_FORM_TAR) == XL_FORM_TAR;
+}
+
+/* BO field analysis (B-form or XL-form) */
+static int is_bo_always(unsigned int instr)
+{
+	return (instr & BO_ALWAYS) == BO_ALWAYS;
+}
+
+static int is_bo_ctr(unsigned int instr)
+{
+        return (instr & BO_CTR) == BO_CTR;
+}
+
+static int is_bo_crbi_off(unsigned int instr)
+{
+	return (instr & BO_CRBI_OFF) == BO_CRBI_OFF;
+}
+
+static int is_bo_crbi_on(unsigned int instr)
+{
+	return (instr & BO_CRBI_ON) == BO_CRBI_ON;
+}
+
+static int is_bo_crbi_hint(unsigned int instr)
+{
+	return (instr & BO_CRBI_HINT) == BO_CRBI_HINT;
+}
+
+/* Link bit is set */
+static int is_branch_link_set(unsigned int instr)
+{
+	return (instr & BRANCH_SET_LINK) == BRANCH_SET_LINK;
+}
+
+/* Perf branch filters */
+bool instr_is_return_branch(unsigned int instr)
+{
+	/*
+	 * Conditional and unconditional branch to LR register
+	 * without seting the link register.
+	 */
+	if (is_xlform_lr(instr) && !is_branch_link_set(instr))
+		return true;
+
+	return false;
+}
+
+bool instr_is_conditional_branch(unsigned int instr)
+{
+	/* I-form instruction - excluded */
+	if (instr_is_branch_iform(instr))
+		return false;
+
+	/* B-form or XL-form instruction */
+	if (instr_is_branch_bform(instr) || instr_is_branch_xlform(instr))  {
+
+		/* Not branch always */
+		if (!is_bo_always(instr)) {
+
+			/* Conditional branch to CTR register */
+			if (is_bo_ctr(instr))
+				return false;
+
+			/* CR[BI] conditional branch with static hint */
+			if (is_bo_crbi_off(instr) || is_bo_crbi_on(instr)) {
+        			if (is_bo_crbi_hint(instr))
+                			 return false;;
+			}
+			return true;
+		}
+	}
+	return false;
+}
+
+bool instr_is_func_call(unsigned int instr)
+{
+	/* LR should be set */
+	if (is_branch_link_set(instr))
+		return true;
+
+	return false;
+}
+
+bool instr_is_indirect_func_call(unsigned int instr)
+{
+	/* XL-form instruction */
+	if (instr_is_branch_xlform(instr)) {
+
+		/* LR should be set */
+		if (is_branch_link_set(instr)) {
+			/*
+			 * Conditional and unconditional
+			 * branch to CTR register.
+			 */
+			 if (is_xlform_ctr(instr))
+				return true;
+
+			/*
+			 * Conditional and unconditional
+			 * branch to LR register.
+			 */
+			if (is_xlform_lr(instr))
+				return true;
+
+			/*
+			 * Conditional and unconditional
+			 * branch to TAR register.
+			 */
+			if (is_xlform_tar(instr))
+				return true;
+		}
+	}
+	return false;
+}
+
 int instr_is_relative_branch(unsigned int instr)
 {
 	if (instr & BRANCH_ABSOLUTE)



