Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaLOLwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:52:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaLOLwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:52:17 -0500
Message-ID: <548ECB6E.5060104@suse.com>
Date: Mon, 15 Dec 2014 12:52:14 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: jongman.heo@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to
 use cache mode translation tables")
References: <1915005366.124751418629936574.JavaMail.weblogic@epmlwas02b>
In-Reply-To: <1915005366.124751418629936574.JavaMail.weblogic@epmlwas02b>
Content-Type: multipart/mixed;
 boundary="------------030402060105020507030906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030402060105020507030906
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit

On 12/15/2014 08:52 AM, Jongman Heo wrote:
>> ------- Original Message -------
>> Sender : Juergen Gross
>> Date : 2014-12-15 14:04 (GMT+09:00)
>> Title : Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to use cache mode translation tables")
>>
>> On 12/14/2014 06:07 AM, ÇãÁ¾¸¸ wrote:
>>>
>>> Hi,
>>>
>>> My Linux virtual machine on (Windows) VMWare workstation 10 can't boot with following commit.
>>>
>>> commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2
>>> Author: Juergen Gross
>>> Date:   Mon Nov 3 14:02:03 2014 +0100
>>>
>>>       x86: Enable PAT to use cache mode translation tables
>>>
>>> Unfortunately I can't see any console log.
>>
>> Hmm, weird. Could you provide some more information?
>>
>> Kernel config, hardware used, /proc/cpuinfo of working kernel?
>> Anything you see with earlyprintk enabled?
>>
>>
>> Juergen
> 
> (Sorry for resending this email, previous one bounced from mailing list due to HTML format)
> 
> Hi,
> 
> I'm using Fedora 21, with custom built kernel.
> Host PC is windows 7 64-bit, and running VMWare workstation 10 for guest Fedora Linux.
> 
> With earlyprintk, just following message is printed.
> 
>    early console in setup code
> 
> and nothing more...

Can you try attached diagnostic patch, please? I suspect a problem
regarding VMWares PAT emulation...


Juergen

--------------030402060105020507030906
Content-Type: text/x-patch;
 name="diag.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diag.patch"

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index edf299c..d77d6a8 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -182,6 +182,7 @@ void pat_init_cache_modes(void)
 	u64 pat;
 
 	rdmsrl(MSR_IA32_CR_PAT, pat);
+	pr_info("read pat %0llx\n", pat);
 	pat_msg[32] = 0;
 	for (i = 7; i >= 0; i--) {
 		cache = pat_get_cache_mode((pat >> (i * 8)) & 7,
@@ -237,6 +238,8 @@ void pat_init(void)
 	if (!boot_pat_state)
 		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
 
+	pr_info("about to write pat %0llx\n", pat);
+
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 
 	if (boot_cpu)

--------------030402060105020507030906--
