Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107Ab3LPFSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 00:18:21 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3LPFSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 00:18:20 -0500
Message-ID: <52AE8D03.2040808@oracle.com>
Date: Mon, 16 Dec 2013 00:17:55 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: vegard.nossum@oracle.com, linux-kernel@vger.kernel.org
CC: Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
In-Reply-To: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On 12/12/2013 11:52 AM, vegard.nossum@oracle.com wrote:
 > +#ifdef CONFIG_EXPLOIT_DETECTION
 > +extern void _exploit(const char *id);

So right now the on/off switch is a kernel config option. I suggest we should add another
dynamic switch (maybe in the form of jump labels) to add an additional level of control:

  - It will allow having an opt-in option. Right now users are forced into
having this feature if the distro maintainers enable it.
	- Which means that distro maintainers are less likely to enable it.

  - If the SHTF and there's something wrong we would want a way to disable it
without having to re-compile the kernel.


<bikeshedding>
Also,

Maybe in the future we could enable/disable specific exploits based on severity or certainty
(how likely that this specific activity is an exploit attempt).

</bikeshedding>

On 12/12/2013 11:52 AM, vegard.nossum@oracle.com wrote:
> +#define exploit_on(cond, id) \
> +	do { \
> +		if (unlikely(cond)) \
> +			_exploit(id); \
> +	} while (0)

What if we make exploit_on() something like this:

	#define exploit_on(cond, id) ({			\
		int __ret_exploit_on = !!(cond);	\
		if (unlikely(__ret_exploit_on))		\
			_exploit(id);			\
		unlikely(__ret_exploit_on);		\
	})

That way we can use it within if() conditionals similar to WARN_ON:

	if (exploit_on(srclen > HFS_NAMELEN, "CVE-2011-4330"))
		srclen = HFS_NAMELEN;



Thanks,
Sasha
