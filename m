Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab3DXG2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:28:49 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46647 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3DXG2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:28:48 -0400
Message-ID: <51777B74.8040204@linux.vnet.ibm.com>
Date: Wed, 24 Apr 2013 11:58:04 +0530
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paulus@samba.org" <paulus@samba.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] PowerPC: kernel: memory access violation when rtas_data_buf
 contents are more than 1026
References: <516F7A7D.60206@asianux.com> <1366677081.2886.7.camel@pasglop> <5175E85F.1040509@asianux.com> <5175FC36.4060308@asianux.com>
In-Reply-To: <5175FC36.4060308@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042406-5490-0000-0000-00000356B5B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 08:42 AM, Chen Gang wrote:
>
> need set '\0' for 'local_buffer'.
>
> SPLPAR_MAXLENGTH is 1026, RTAS_DATA_BUF_SIZE is 4096. so the contents of
> rtas_data_buf may truncated in memcpy.
>
> if contents are really truncated.
>    the splpar_strlen is more than 1026. the next while loop checking will
>    not find the end of buffer. that will cause memory access violation.
>

Per parameter length in ibm,get-system-parameter RTAS call is limited to 1026 
bytes (1024 bytes of data + 2 bytes  length). And 'rtas_data_buf' was set to 0 
(first 1026 bytes) before call RTAS call. At the worst if we get junk in RTAS 
output length field helps to exit from the while loop. So I don't think we need 
this patch.

-Vasant

>
> Signed-off-by: Chen Gang<gang.chen@asianux.com>
> ---
>   arch/powerpc/kernel/lparcfg.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
> index 801a757..d92f387 100644
> --- a/arch/powerpc/kernel/lparcfg.c
> +++ b/arch/powerpc/kernel/lparcfg.c
> @@ -299,6 +299,7 @@ static void parse_system_parameter_string(struct seq_file *m)
>   				__pa(rtas_data_buf),
>   				RTAS_DATA_BUF_SIZE);
>   	memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
> +	local_buffer[SPLPAR_MAXLENGTH - 1] = '\0';
>   	spin_unlock(&rtas_data_buf_lock);
>
>   	if (call_status != 0) {

