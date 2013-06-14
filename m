Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3FNQej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:34:39 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:40234
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751425Ab3FNQei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:34:38 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jun 2013 12:34:38 EDT
Message-ID: <51BB44CA.6050304@caviumnetworks.com>
Date: Fri, 14 Jun 2013 09:28:58 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        <linux-mips@linux-mips.org>
Subject: Re: [PATCH v2] MIPS: Reduce _NSIG from 128 to 127 to avoid BUG_ON
References: <1371225825-8225-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1371225825-8225-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-Antispam-Report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:0;SRVR:CO1PR07MB205;H:BY2PRD0712HT003.namprd07.prod.outlook.com;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 09:03 AM, James Hogan wrote:
> MIPS has 128 signals, the highest of which has the number 128 (they
> start from 1). The following command causes get_signal_to_deliver() to
> pass this signal number straight through to do_group_exit() as the exit
> code:
>
>    strace sleep 10 & sleep 1 && kill -128 `pidof sleep`
>
> However do_group_exit() checks for the core dump bit (0x80) in the exit
> code which matches in this particular case and the kernel panics:
>
>    BUG_ON(exit_code & 0x80); /* core dumps don't get here */
>
> Lets avoid this by changing the ABI by reducing the number of signals to
> 127 (so that the maximum signal number is 127). Glibc incorrectly sets
> [__]SIGRTMAX to 127 already. uClibc sets it to 128 so it's conceivable
> that programs built against uClibc which intentionally uses RT signals
> from the top (SIGRTMAX-n, n>=0) would need an updated uClibc (and a
> rebuild if it's crazy enough to use __SIGRTMAX).
>
> Note that the signals man page seems to make clear that signals should
> be referred to from SIGRTMIN, and it seems unlikely that any portable
> program would ever need to use 96 RT signals:
>
>    "programs should never refer to real-time signals using hard-coded
>    numbers, but instead should always refer to real-time signals using
>    the notation SIGRTMIN+n, and include suitable (run-time) checks that
>    SIGRTMIN+n does not exceed SIGRTMAX."
>

As previously discussed, I think this is the way to go,

Acked-by: David Daney <david.daney@cavium.com>


> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: David Daney <david.daney@cavium.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Dave Jones <davej@redhat.com>
> Cc: linux-mips@linux-mips.org
> ---
> As discussed on IRC, another possibility is to reduce the number of
> signals down to 64 to match other arches and reduce the number of
> sigset_t words, but I think that's riskier as it would affect glibc too.
>
>   arch/mips/include/uapi/asm/signal.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/include/uapi/asm/signal.h b/arch/mips/include/uapi/asm/signal.h
> index addb9f5..40e944d 100644
> --- a/arch/mips/include/uapi/asm/signal.h
> +++ b/arch/mips/include/uapi/asm/signal.h
> @@ -11,9 +11,9 @@
>
>   #include <linux/types.h>
>
> -#define _NSIG		128
> +#define _NSIG		127
>   #define _NSIG_BPW	(sizeof(unsigned long) * 8)
> -#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
> +#define _NSIG_WORDS	((_NSIG + _NSIG_BPW - 1) / _NSIG_BPW)
>
>   typedef struct {
>   	unsigned long sig[_NSIG_WORDS];
>

