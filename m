Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab3B0Wx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:53:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58726 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab3B0Wx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:53:26 -0500
Message-ID: <512E8E49.3050206@zytor.com>
Date: Wed, 27 Feb 2013 14:52:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECK
References: <1361934016-22630-1-git-send-email-sboyd@codeaurora.org> <201302272032.21014.arnd@arndb.de> <512E6FA9.4060504@codeaurora.org> <512E8664.3070903@zytor.com> <20130228094510.3341017130e4476e046bdd22@canb.auug.org.au>
In-Reply-To: <20130228094510.3341017130e4476e046bdd22@canb.auug.org.au>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 02:45 PM, Stephen Rothwell wrote:
> Hi all,
> 
> On Wed, 27 Feb 2013 14:19:16 -0800 "H. Peter Anvin" <hpa@zytor.com>
> wrote:
>> 
>> Although some of the cases I have seen being flagged as "false 
>> positives" have been real bugs.
> 
> [hijacking the thread :-)]
> 
> I have been getting this warning for a very long time ( which would
> be an error if CONFIG_DEBUG_STRICT_USER_COPY_CHECK was set):
> 
> i386 defconfig i386-linux-gcc (GCC) 4.6.3
> 
> In file included from arch/x86/include/asm/uaccess.h:537:0, from
> include/linux/uaccess.h:5, from include/linux/highmem.h:8, from
> include/linux/pagemap.h:10, from fs/binfmt_misc.c:27: 
> arch/x86/include/asm/uaccess_32.h: In function
> 'parse_command.part.2': arch/x86/include/asm/uaccess_32.h:211:26:
> warning: call to 'copy_from_user_overflow' declared with attribute
> warning: copy_from_user() buffer size is not provably correct
> [enabled by default]
> 

OK, that is surprising, because that copy is very clearly properly
guarded:

static int parse_command(const char __user *buffer, size_t count)
{
	char s[4];

	if (!count)
		return 0;
	if (count > 3)
		return -EINVAL;
	if (copy_from_user(s, buffer, count))
		return -EFAULT;

It isn't possible for count to be anything other than 1, 2 or 3 there,
and it is very surprising that gcc can't see it.

This might be worth filing a gcc bug for.

	-hpa

