Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaEWIUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:20:43 -0400
Received: from mail.siteground.com ([67.19.240.234]:36929 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaEWIUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:20:40 -0400
Message-ID: <537F04BF.3000301@1h.com>
Date: Fri, 23 May 2014 11:20:15 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: "Serge E. Hallyn" <serge@hallyn.com>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Arnd Bergmann <arnd@arndb.de>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Richard Weinberger <richard@nod.at>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
References: <1400120251.7699.11.camel@canyon.ip6.wittsend.com> <20140515031527.GA146352@ubuntu-hedt> <20140515040032.GA6702@kroah.com> <1400161337.7699.33.camel@canyon.ip6.wittsend.com> <20140515140856.GA17453@kroah.com> <CAFLxGvwfbVdLUq0NrSrQNYH+bTzYLuCE2moooHH319qRfDkS6Q@mail.gmail.com> <20140515195010.GA22317@ubuntumail> <53751FFA.5040103@nod.at> <20140515202628.GB25896@mail.hallyn.com> <CALCETrWE72G86QKVZT2aqWsEmjwOPwsWMUNz5-JkDvbqaGbrvw@mail.gmail.com> <20140520141931.GH26600@ubuntumail>
In-Reply-To: <20140520141931.GH26600@ubuntumail>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/20/2014 05:19 PM, Serge Hallyn wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> On May 15, 2014 1:26 PM, "Serge E. Hallyn" <serge@hallyn.com> wrote:
>>> 
>>> Quoting Richard Weinberger (richard@nod.at):
>>>> Am 15.05.2014 21:50, schrieb Serge Hallyn:
>>>>> Quoting Richard Weinberger (richard.weinberger@gmail.com):
>>>>>> On Thu, May 15, 2014 at 4:08 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>>>>>> Then don't use a container to build such a thing, or fix the build scripts to not do that :)
>>>>>> 
>>>>>> I second this. To me it looks like some folks try to (ab)use Linux containers for purposes where KVM
>>>>>> would much better fit in. Please don't put more complexity into containers. They are already horrible
>>>>>> complex and error prone.
>>>>> 
>>>>> I, naturally, disagree :)  The only use case which is inherently not valid for containers is running a
>>>>> kernel.  Practically speaking there are other things which likely will never be possible, but if someone 
>>>>> offers a way to do something in containers, "you can't do that in containers" is not an apropos response.
>>>>> 
>>>>> "That abstraction is wrong" is certainly valid, as when vpids were originally proposed and rejected,
>>>>> resulting in the development of pid namespaces.  "We have to work out (x) first" can be valid (and I can
>>>>> think of examples here), assuming it's not just trying to hide behind a catch-22/chicken-egg problem.
>>>>> 
>>>>> Finally, saying "containers are complex and error prone" is conflating several large suites of userspace
>>>>> code and many kernel features which support them.  Being more precise would, if the argument is valid, lend
>>>>> it a lot more weight.
>>>> 
>>>> We (my company) use Linux containers since 2011 in production. First LXC, now libvirt-lxc. To understand the
>>>> internals better I also wrote my own userspace to create/start containers. There are so many things which can
>>>> hurt you badly. With user namespaces we expose a really big attack surface to regular users. I.e. Suddenly a
>>>> user is allowed to mount filesystems.
>>> 
>>> That is currently not the case.  They can mount some virtual filesystems and do bind mounts, but cannot mount
>>> most real filesystems.  This keeps us protected (for now) from potentially unsafe superblock readers in the 
>>> kernel.
>>> 
>>>> Ask Andy, he found already lots of nasty things...
>> 
>> I don't think I have anything brilliant to add to this discussion right now, except possibly:
>> 
>> ISTM that Linux distributions are, in general, vulnerable to all kinds of shenanigans that would happen if an
>> untrusted user can cause a block device to appear.  That user doesn't need permission to mount it
> 
> Interesting point.  This would further suggest that we absolutely must ensure that a loop device which shows up in
> the container does not also show up in the host.

Can I suggest the usage of the devices cgroup to achieve that?

Marian

> 
>> or even necessarily to change its contents on the fly.
>> 
>> E.g. what happens if you boot a machine that contains a malicious disk image that has the same partition UUID as
>> /?  Nothing good, I imagine.
>> 
>> So if we're going to go down this road, we really need some way to tell the host that certain devices are not
>> trusted.
>> 
>> --Andy
> -- To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html Please read the FAQ at
> http://www.tux.org/lkml/
> 


- -- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlN/BL8ACgkQ4mt9JeIbjJRuTwCgjpP8cNle5deHpUSJJoDkcfin
byEAn3Fy4wwiZ3avNwA/ljZWVWeGFU8W
=iQLO
-----END PGP SIGNATURE-----
