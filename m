Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937125Ab3DIJhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:37:24 -0400
Received: from intranet.asianux.com ([58.214.24.6]:36086 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab3DIJhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:37:08 -0400
X-Spam-Score: -100.7
Message-ID: <5163E123.5080205@asianux.com>
Date: Tue, 09 Apr 2013 17:36:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: module: strncpy issue, using strlcpy instead
 of strncpy
References: <51615AB0.9060502@asianux.com> <87r4ila8sb.fsf@rustcorp.com.au> <516298E0.9000905@asianux.com> <8738v19lv0.fsf@rustcorp.com.au> <51637441.2090006@asianux.com>
In-Reply-To: <51637441.2090006@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月09日 09:52, Chen Gang wrote:
>>>>
>>>>   it looks like a bug.  for me, I prefer to give length check for it.
>>>>
>>>>   but I am sorry, now, I can not be sure whether it is really a bug.
>> It really is.  We don't export any symbols > 128 characters, but if we
>> did then kallsyms_expand_symbol() would overflow the buffer handed to
>> it.
>>
>> Your suggestion about an explicit length for kallsyms_expand_symbol() is
>> the correct one.
> 
> 

  oh, sorry, after read the related source code, I think:

    for kernel/kallsyms.c, it is no issue
      (although I still also prefer to give a length checking).

    the reason is:
      scripts/kallsyms.c does not check the 128 limitation.
      if compiler limits it with 128 automatically, we will have no issue.
      else the scripts/kallsyms will cause issue.

    so whether what happens, kernel/kallsyms.c will not cause issue.

    :-)


  the related patch for scripts/kallsyms.c is below, please check, thanks.
    (now, it is just for a reference, after have a test, I will send).


-----------------------patch begin--------------------------------------

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 487ac6f..9ec6d1f 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -145,13 +145,15 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 	/* include the type field in the symbol name, so that it gets
 	 * compressed together */
 	s->len = strlen(str) + 1;
+	if (s->len > KSYM_NAME_LEN)
+		s->len = KSYM_NAME_LEN;
 	s->sym = malloc(s->len + 1);
 	if (!s->sym) {
 		fprintf(stderr, "kallsyms failure: "
 			"unable to allocate required amount of memory\n");
 		exit(EXIT_FAILURE);
 	}
-	strcpy((char *)s->sym + 1, str);
+	strlcpy((char *)s->sym + 1, str, KSYM_NAME_LEN);
 	s->sym[0] = stype;
 
 	return 0;
@@ -290,7 +292,7 @@ static void write_src(void)
 	unsigned int i, k, off;
 	unsigned int best_idx[256];
 	unsigned int *markers;
-	char buf[KSYM_NAME_LEN];
+	char buf[KSYM_NAME_LEN + 1];
 
 	printf("#include <asm/types.h>\n");
 	printf("#if BITS_PER_LONG == 64\n");
-- 
1.7.7.6


-----------------------patch end----------------------------------------



>   thank you to give me additional chance to send a new patch,
>   I will send another patch for it.
> 
>   since you find it, firstly, and also give a confirmation.
>   can I add you as "Signed-of-by", too ?
> 
>   and excuse me:
>     I think I should spend time resources to have a test for new patch.
>     so I will finish it within this weekend (2013-4-14), is it OK ?
> 
> 
>   thanks.
> 
> 


-- 
Chen Gang

Asianux Corporation
