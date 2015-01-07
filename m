Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbbAGTsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:48:31 -0500
Received: from smtpsal1.cc.upv.es ([158.42.249.61]:54616 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753603AbbAGTsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:48:30 -0500
Message-ID: <20150107204754.191110bihbw3t10q@webmail.upv.es>
Date: Wed, 07 Jan 2015 20:47:54 +0100
From: Hector Marco Gisbert <hecmargi@upv.es>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Ismael Ripoll Ripoll <iripoll@disca.upv.es>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATH] Fix stack randomization on x86_64 bit
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[PATH] Fix stack randomization on x86_64 bit

The issue is that the stack for processes is not properly randomized on 64 bit
architectures due to an integer overflow.


The affected function is randomize_stack_top() in file "fs/binfmt_elf.c":

static unsigned long randomize_stack_top(unsigned long stack_top)
{
         unsigned int random_variable = 0;

         if ((current->flags & PF_RANDOMIZE) &&
                 !(current->personality & ADDR_NO_RANDOMIZE)) {
                 random_variable = get_random_int() & STACK_RND_MASK;
                 random_variable <<= PAGE_SHIFT;
         }
#ifdef CONFIG_STACK_GROWSUP
         return PAGE_ALIGN(stack_top) + random_variable;
#else
         return PAGE_ALIGN(stack_top) - random_variable;
#endif
}


Note that, it declares the "random_variable" variable as "unsigned int". Since
the result of the shifting operation between STACK_RND_MASK (which is  
0x3fffff on
x86_64, 22 bits) and PAGE_SHIFT (which is 12 on x86_64):

random_variable <<= PAGE_SHIFT;

then the two leftmost bits are dropped when storing the result in the
"random_variable". This variable shall be at least 34 bits long to hold the
(22+12) result.

These two dropped bits have an impact on the entropy of process stack.
Concretely, the total stack entropy is reduced by four: from 2^28 to 2^30 (One
fourth of expected entropy).

This patch restores back the entropy by correcting the types involved in the
operations in the functions randomize_stack_top() and stack_maxrandom_size().


Signed-off-by: Hector Marco-Gisbert <hecmargi@upv.es>
Signed-off-by: Ismael Ripoll <iripoll@upv.es>


diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 919b912..df4552b 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -35,12 +35,12 @@ struct va_alignment __read_mostly va_align = {
  	.flags = -1,
  };

-static unsigned int stack_maxrandom_size(void)
+static unsigned long stack_maxrandom_size(void)
  {
-	unsigned int max = 0;
+	unsigned long max = 0;
  	if ((current->flags & PF_RANDOMIZE) &&
  		!(current->personality & ADDR_NO_RANDOMIZE)) {
-		max = ((-1U) & STACK_RND_MASK) << PAGE_SHIFT;
+		max = ((-1UL) & STACK_RND_MASK) << PAGE_SHIFT;
  	}

  	return max;
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d8fc060..ee668b4 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -554,11 +554,11 @@ out:

  static unsigned long randomize_stack_top(unsigned long stack_top)
  {
-	unsigned int random_variable = 0;
+	unsigned long random_variable = 0;

  	if ((current->flags & PF_RANDOMIZE) &&
  		!(current->personality & ADDR_NO_RANDOMIZE)) {
-		random_variable = get_random_int() & STACK_RND_MASK;
+		random_variable = (unsigned long) get_random_int() & STACK_RND_MASK;
  		random_variable <<= PAGE_SHIFT;
  	}
  #ifdef CONFIG_STACK_GROWSUP


