Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3AOKIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:08:48 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:57236 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab3AOKIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:08:45 -0500
Date: Tue, 15 Jan 2013 11:08:36 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: kvm/sigp.c: fix memory leakage
Message-ID: <20130115110836.771d1622@gondolin>
In-Reply-To: <1358199594-15594-1-git-send-email-dinggnu@gmail.com>
References: <1358199594-15594-1-git-send-email-dinggnu@gmail.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 13011510-3548-0000-0000-00000442C2FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013 22:39:54 +0100
Cong Ding <dinggnu@gmail.com> wrote:

> the variable inti should be freed in the branch CPUSTAT_STOPPED.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  arch/s390/kvm/sigp.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> index 461e841..1c48ab2 100644
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -137,8 +137,10 @@ static int __inject_sigp_stop(struct kvm_s390_local_interrupt *li, int action)
>  	inti->type = KVM_S390_SIGP_STOP;
> 
>  	spin_lock_bh(&li->lock);
> -	if ((atomic_read(li->cpuflags) & CPUSTAT_STOPPED))
> +	if ((atomic_read(li->cpuflags) & CPUSTAT_STOPPED)) {
> +		kfree(inti);
>  		goto out;
> +	}
>  	list_add_tail(&inti->list, &li->list);
>  	atomic_set(&li->active, 1);
>  	atomic_set_mask(CPUSTAT_STOP_INT, li->cpuflags);

Thanks, applied.

