Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaGQUfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 16:35:21 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56314 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaGQUfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 16:35:19 -0400
Message-ID: <53C83383.4040507@amacapital.net>
Date: Thu, 17 Jul 2014 13:35:15 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Kettenis <mark.kettenis@xs4all.nl>, "Theodore Ts'o" <tytso@mit.edu>
CC: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
References: <201407171848.s6HImBb4027900@glazunov.sibelius.xs4all.nl>
In-Reply-To: <201407171848.s6HImBb4027900@glazunov.sibelius.xs4all.nl>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 11:48 AM, Mark Kettenis wrote:
> On Thu, Jul 17, 2014, Theodore Ts'o wrote:
>>
>> The getrandom(2) system call is a superset of getentropy(2).  When we
>> add the support for this into glibc, it won't be terribly difficult
>> nor annoying to drop the following in alongside the standard support
>> needed for any new system call:
>>
>> int getentropy(void *buf, size_t buflen)
>> {
>> 	int	ret;
>>
>> 	ret = getentropy(buf, buflen, 0);
>> 	return (ret > 0) ? 0 : ret;
>> }
> 
> I'm sure you meant to use getrandom() there ;)
> 
> Since for LibreSSL we'd want a getentropy() that cannot fail the
> getrandom() call should use GRND_BLOCK flag.  Actually it makes sense
> (to me) to make blocking the default behaviour and have a
> BRND_NONBLOCK flag.  Much in the same way as you need to specify
> O_NONBLOCK if you want non-blocking behaviour for files.
> 

Can we please have a mode in which getrandom(2) can neither block nor
fail?  If that gets added, then this can replace things like AT_RANDOM.

There are non-crypto things out there that will want this.  There are
also probably VM systems (especially ones that have something like my
KVM_GET_RNG_SEED patches applied, or many VMs on Haswell, for that
matter) that will have perfectly fine cryptographically secure urandom
output immediately after bootup but that won't consider themselves
"initialized" for a while.  At least these will be perfectly fine from
the POV of those who trust their hypervisor and Intel :)

--Andy
