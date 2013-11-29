Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab3K2U4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 15:56:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33159 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab3K2U4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:56:38 -0500
Date: Fri, 29 Nov 2013 21:56:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Levente Kurusa <levex@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, EDAC <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
Message-ID: <20131129205628.GA20144@pd.tnic>
References: <5298F900.9000208@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5298F900.9000208@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 09:28:48PM +0100, Levente Kurusa wrote:
> This patch adds a call to put_device() when the device_register()
> call has failed. This is required so that the last reference to the
> device is given up.

I'd assume this is not something you're actually hitting but have caught
this by code staring...?

> Signed-off-by: Levente Kurusa <levex@linux.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index b3218cd..a389c1d 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2272,8 +2272,10 @@ static int mce_device_create(unsigned int cpu)
>  	dev->release = &mce_device_release;
> 
>  	err = device_register(dev);
> -	if (err)
> +	if (err) {
> +		put_device(dev);
>  		return err;
> +	}

If we're going to do this, I'd also like to see you add another label
after device_unregister(dev) which also kfrees dev because apparently
we're not doing that either.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
