Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaKJWGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:06:09 -0500
Received: from mail-bl2on0119.outbound.protection.outlook.com ([65.55.169.119]:35866
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752100AbaKJWGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:06:07 -0500
X-WSS-ID: 0NEUG1Y-08-6I2-02
X-M-MSG: 
Message-ID: <546136C8.5060104@amd.com>
Date: Mon, 10 Nov 2014 16:06:00 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chen Yucong <slaoub@gmail.com>, <bp@alien8.de>, <tony.luck@intel.com>
CC: <ak@linux.intel.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] x86, mce, severity: extend the the mce_severity
 mechanism to handle UCNA/DEFERRED error
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
 <1415410821-15063-2-git-send-email-slaoub@gmail.com>
In-Reply-To: <1415410821-15063-2-git-send-email-slaoub@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(51704005)(199003)(377454003)(479174003)(189002)(76176999)(87266999)(50986999)(54356999)(36756003)(99396003)(102836001)(33656002)(120886001)(120916001)(87936001)(83506001)(92726001)(23756003)(84676001)(68736004)(86362001)(2201001)(92566001)(64126003)(97736003)(575784001)(101416001)(65816999)(44976005)(80316001)(19580405001)(19580395003)(62966003)(77156002)(50466002)(65956001)(65806001)(105586002)(106466001)(95666004)(20776003)(47776003)(64706001)(21056001)(46102003)(59896002)(31966008)(4396001)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/2014 7:40 PM, Chen Yucong wrote:
> Until now, the mce_severity mechanism can only identify the severity
> of UCNA error as MCE_KEEP_SEVERITY. Meanwhile, it is not able to filter
> out DEFERRED error for ADM platform.
>
> This patch aims to extend the mce_severity mechanism for handling
> UCNA/DEFERRED error. In order to do this, the patch introduces a new
> severity level - MCE_UCNA/DEFERRED_SEVERITY.
>
> In addition, mce_severity is specific to machine check exception,
> and it will check MCIP/EIPV/RIPV bits. In order to use mce_severity
> mechanism in non-exception context, the patch also introduces a new
> argument (is_excp) for mce_severity. `is_excp' is used to explicitly
> specify the calling context of mce_severity.
>
> Signed-off-by: Chen Yucong <slaoub@gmail.com>
> ---
>   arch/x86/include/asm/mce.h                |    4 ++++
>   arch/x86/kernel/cpu/mcheck/mce-internal.h |    4 +++-
>   arch/x86/kernel/cpu/mcheck/mce-severity.c |   21 ++++++++++++++++-----
>   arch/x86/kernel/cpu/mcheck/mce.c          |   14 ++++++++------
>   drivers/edac/mce_amd.h                    |    3 ---
>   5 files changed, 31 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index 276392f..51b26e89 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -34,6 +34,10 @@
>   #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
>   #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
>   
> +/* AMD-specific bits */
> +#define MCI_STATUS_DEFERRED	(1ULL<<44)  /* declare an uncorrected error */
> +#define MCI_STATUS_POISON	(1ULL<<43)  /* access poisonous data */
> +
>   /*
>    * Note that the full MCACOD field of IA32_MCi_STATUS MSR is
>    * bits 15:0.  But bit 12 is the 'F' bit, defined for corrected
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
> index 09edd0b..10b4690 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
> +++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
> @@ -3,6 +3,8 @@
>   
>   enum severity_level {
>   	MCE_NO_SEVERITY,
> +	MCE_DEFERRED_SEVERITY,
> +	MCE_UCNA_SEVERITY = MCE_DEFERRED_SEVERITY,
>   	MCE_KEEP_SEVERITY,
>   	MCE_SOME_SEVERITY,
>   	MCE_AO_SEVERITY,
> @@ -21,7 +23,7 @@ struct mce_bank {
>   	char			attrname[ATTR_LEN];	/* attribute name */
>   };
>   
> -int mce_severity(struct mce *a, int tolerant, char **msg);
> +int mce_severity(struct mce *a, int tolerant, char **msg, bool is_excp);
>   struct dentry *mce_get_debugfs_dir(void);
>   
>   extern struct mce_bank *mce_banks;
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> index c370e1c..c61feb3 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> @@ -31,6 +31,7 @@
>   
>   enum context { IN_KERNEL = 1, IN_USER = 2 };
>   enum ser { SER_REQUIRED = 1, NO_SER = 2 };
> +enum exception { EXCP_CONTEXT = 1, NO_EXCP = 2 };
>   
>   static struct severity {
>   	u64 mask;
> @@ -40,6 +41,7 @@ static struct severity {
>   	unsigned char mcgres;
>   	unsigned char ser;
>   	unsigned char context;
> +	unsigned char excp;
>   	unsigned char covered;
>   	char *msg;
>   } severities[] = {
> @@ -48,6 +50,8 @@ static struct severity {
>   #define  USER		.context = IN_USER
>   #define  SER		.ser = SER_REQUIRED
>   #define  NOSER		.ser = NO_SER
> +#define  EXCP		.excp = EXCP_CONTEXT
> +#define  NOEXCP		.excp = NO_EXCP
>   #define  BITCLR(x)	.mask = x, .result = 0
>   #define  BITSET(x)	.mask = x, .result = x
>   #define  MCGMASK(x, y)	.mcgmask = x, .mcgres = y
> @@ -71,16 +75,20 @@ static struct severity {
>   	/* When MCIP is not set something is very confused */
>   	MCESEV(
>   		PANIC, "MCIP not set in MCA handler",
> -		MCGMASK(MCG_STATUS_MCIP, 0)
> +		EXCP, MCGMASK(MCG_STATUS_MCIP, 0)
>   		),
>   	/* Neither return not error IP -- no chance to recover -> PANIC */
>   	MCESEV(
>   		PANIC, "Neither restart nor error IP",
> -		MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
> +		EXCP, MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
>   		),
>   	MCESEV(
>   		PANIC, "In kernel and no restart IP",
> -		KERNEL, MCGMASK(MCG_STATUS_RIPV, 0)
> +		EXCP, KERNEL, MCGMASK(MCG_STATUS_RIPV, 0)
> +		),
> +	MCESEV(
> +		DEFERRED, "Deferred error",
> +		NOSER, MASK(MCI_STATUS_UC|MCI_STATUS_DEFERRED|MCI_STATUS_POISON, MCI_STATUS_DEFERRED)
>   		),

We don't need to have MCI_STATUS_POISON in the MASK() here as a deferred 
error is indicated by a {UC=0, Deferred = 1}
(Older docs might be unclear on that..)

And it still says ADM on the commit message :)

- Aravind.
