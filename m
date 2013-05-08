Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab3EHUud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:50:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541Ab3EHUuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:50:32 -0400
Date: Wed, 8 May 2013 13:50:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v8 11/11] Move arch/x86 reboot= handling to generic
 kernel.
Message-Id: <20130508135029.ffbeefa6b8154bee31e7bbbe@linux-foundation.org>
In-Reply-To: <1367937595-32241-12-git-send-email-holt@sgi.com>
References: <1367937595-32241-1-git-send-email-holt@sgi.com>
	<1367937595-32241-12-git-send-email-holt@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 May 2013 09:39:55 -0500 Robin Holt <holt@sgi.com> wrote:

> Merge together the unicore32, arm, and x86 reboot= command line
> parameter handling.
> 
> ...
>
> +static int __init reboot_setup(char *str)
> +{
> +	for (;;) {
> +		/*
> +		 * Having anything passed on the command line via
> +		 * reboot= will cause us to disable DMI checking
> +		 * below.
> +		 */
> +		reboot_default = 0;
> +
> +		switch (*str) {
> +#if defined(CONFIG_X86) || defined(CONFIG_X86_64)
> +		case 'w':
> +			reboot_mode = REBOOT_WARM;
> +			break;
> +
> +		case 'c':
> +			reboot_mode = REBOOT_COLD;
> +			break;
> +
> +#ifdef CONFIG_SMP
> +		case 's':
> +			if (isdigit(*(str+1))) {
> +				reboot_cpu = (int) (*(str+1) - '0');
> +				if (isdigit(*(str+2)))
> +					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
> +			}

Boy, that's some weird stuff.

What's wrong with doing

			if (isdigit(str[1])) {
				reboot_cpu = str[1] - '0';
				if (isdigit(str[2]))
					reboot_cpu = reboot_cpu * 10 +
							str[2] - '0';
			}

?

But it's still nonsense - we should eliminate its
you-have-less-than-101-CPUs restriction by using, you know, atoi().

