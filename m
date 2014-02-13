Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaBMEDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 23:03:06 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35387 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaBMEDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 23:03:04 -0500
MIME-Version: 1.0
X-Originating-IP: [67.83.169.196]
In-Reply-To: <1392260382.2214.18.camel@joe-AO722>
References: <1392257593-3736-1-git-send-email-patrick@parcs.ath.cx>
	<1392260382.2214.18.camel@joe-AO722>
Date: Wed, 12 Feb 2014 23:03:03 -0500
Message-ID: <CA+C-WL9ARNvOqeA4n5Abnja+99O4F1VdMDUPjuRCcXiVsMTc7A@mail.gmail.com>
Subject: Re: [PATCH] ext4: address a benign compiler warning
From: Patrick Palka <patrick@parcs.ath.cx>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 9:59 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-02-12 at 21:13 -0500, Patrick Palka wrote:
>> When !defined(CONFIG_EXT4_DEBUG), mb_debug() should be defined as an
>> empty do-while statement so as to suppress the following compiler
>> warning:
>
> Hello Patrick.
>
>> fs/ext4/mballoc.c: In function 'ext4_mb_cleanup_pa':
>> fs/ext4/mballoc.c:2659:47: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
>>    mb_debug(1, "mballoc: %u PAs left\n", count);
>> ---
>> diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
> []
>> @@ -48,7 +48,7 @@ extern ushort ext4_mballoc_debug;
>>               }                                                       \
>>       } while (0)
>>  #else
>> -#define mb_debug(n, fmt, a...)
>> +#define mb_debug(n, fmt, a...)               do { } while (0)
>
> Ideally, this section should be something like below
> so the !CONFIG_EXT4_DEBUG case still verifies that
> the format and argument types match.
>
> This can help avoid people adding debug statements but
> not compiling with the proper CONFIG_<foo> variable set.
>
> ---
>
> #ifdef CONFIG_EXT4_DEBUG
> extern ushort ext4_mballoc_debug;
>
> #define mb_debug(n, fmt, ...)                                   \
> do {                                                            \
>         if ((n) <= ext4_mballoc_debug)                          \
>                 pr_debug(fmt, ##__VA_ARGS__);                   \
>         }                                                       \
> } while (0)
> #else
> #define mb_debug(n, fmt, ...)                                   \
>         no_printk(KERN_DEBUG fmt, ##__VA_ARGS__)
> #endif
>
>

Hi Joe,

Thanks!  I was not aware of that idiom.  It makes a good amount of
sense.  I'm going to send a revised version of the patch shortly.

Patrick
