Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3BATZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:25:23 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36939 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3BATZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:25:20 -0500
Message-ID: <510C169C.8050400@wwwdotorg.org>
Date: Fri, 01 Feb 2013 12:25:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, Stephen Warren <swarren@nvidia.com>,
        srinivas.kandagatla@st.com, devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
        Grant Likely <glikely@secretlab.ca>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH V7] kbuild: create a rule to run the pre-processor on
 *.dts files
References: <1357152215-5845-1-git-send-email-swarren@wwwdotorg.org> <510B8480.7000507@st.com> <510BF281.1080309@gmail.com> <510BFB02.6000002@wwwdotorg.org>
In-Reply-To: <510BFB02.6000002@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 10:27 AM, Stephen Warren wrote:
> On 02/01/2013 09:51 AM, Rob Herring wrote:
>> On 02/01/2013 03:01 AM, Srinivas KANDAGATLA wrote:
>>> Hi Stephen,
>>> Not sure if you have already noticed this but,
>>> I did try this patch on my 3.8, and it looks like the intermediate dts
>>> file replaces all instances of linux with 1 because of predefined macros
>>> in gcc.
>>> As a result
>>>     linux,stdout-path = "/soc/stm-asc2";
>>> is changed to.
>>>     1,stdout-path = "/soc/stm-asc2";
>>>
>>> On my version of compiler(gcc version 4.6.3) I have
>>>
>>> armv7-linux-gcc -E -dM - < /dev/null | grep -v _
>>> #define unix 1
>>> #define linux 1
>>>
>>> Which might be true with most compiler versions aswell.
>>> As we are using linux as prefix for some device tree properties it makes
>>> sense to undef the linux gcc define.
>>> Adding -Ulinux to cmd_dtc_cpp should fix it.
>>>
>>> -cmd_dtc_cpp = $(CPP) $(cpp_flags) -D__DTS__ -x assembler-with-cpp -o
>>> $(dtc-tmp) $< ; \
>>> +cmd_dtc_cpp = $(CPP) $(cpp_flags) -D__DTS__  -Ulinux -x
>>> assembler-with-cpp -o $(dtc-tmp) $< ; \
>>>     $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) $(dtc-tmp)
>>
>> That's a hackish solution that seems fragile as well. Is there no way to
>> turn off all built-in defines?
> 
> I'm pretty sure there is; I'll go find it.

Hmmm. I can't actually find one.

> But we do want to keep some of the built-in defines. for example, -x
> assembler-with-cpp turns on __ASSEMBLY__ or similar, which headers can
> use to determine whether to only set up #defines, or also C-oriented
> stuff like types/prototypes. So, at least that one would need to be
> explicitly re-defined.

I grep'd through the kernel's include/ and there are quite a few hits
for some of the pre-define macros such as __linux__, __GNUC__,
__STRICT_ANSI__, __KERNEL__, __arm__ (and presumably other arch macros),
etc. I'd guess that an explicit blacklisting of -Dlinux and -Dunix might
be the most manageable path. Thoughts?
