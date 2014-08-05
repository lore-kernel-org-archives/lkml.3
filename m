Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbaHEPzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:55:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbaHEPzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:55:43 -0400
Message-ID: <53E0FE7C.6030002@suse.cz>
Date: Tue, 05 Aug 2014 17:55:40 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: Use symbolic link to the source tree for out-of-tree
 build
References: <1404887241-14455-1-git-send-email-yamada.m@jp.panasonic.com> <53BD048F.4000800@suse.cz> <20140709182542.B0CB.AA925319@jp.panasonic.com>
In-Reply-To: <20140709182542.B0CB.AA925319@jp.panasonic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-09 11:25, Masahiro Yamada wrote:
> Hi Michal,
> 
> 
> On Wed, 09 Jul 2014 10:59:59 +0200
> Michal Marek <mmarek@suse.cz> wrote:
> 
>> On 2014-07-09 08:27, Masahiro Yamada wrote:
>>> Since commit 9da0763bd, the variable 'srctree' is set as follows:
>>>
>>> [1] Building in the source tree
>>>       => srctree is set to '.'
>>> [2] Building in a subdir right under the source tree
>>>       => srctree is set to '..'
>>> [3] Other cases
>>>       => srctree is set to the absolute path to the source tree
>>>
>>> Pros are more readable compiler messages, WARN_ON() etc.
>>> for case [1] and [2]. (but not [3])
>>>
>>> Cons are we have to do build-test for 3 cases when adding
>>> some changes to the build infrastructure.
>>>
>>> We want to treat case [2] and [3] in the same way like prior to
>>> commit 9da0763bd, keeping the compact log messages.
>>>
>>> The idea here is to create a symbolic link 'srctree' pointing
>>> to $(KBUILD_SRC) at the very early stage of the build process.
>>
>> If the symlink points to an absolute path, then you can't move the
>> source and build tree around anymore.
> 
> 
> In which cases do we need to do this?

Sorry for the late response.

You might want to nfs-export the build and source tree and mount it on a
different machine. Up to 3.16, one had to make sure that the paths match
on both machines. 3.16 removes this limitation.


> Anyway, even if we move the source and build tree around,
> it is much faster to rebuild it.
> 
> The point here is that the absolute paths do not appear
> in .*.cmd files.

If you either do not use O= or use O=<subdir>, then there won't be any
absolute paths either. It could be extended to handle
O=subdir1/subdir1/... if needed.


> For example,
> 
> $ make O=foo/bar defconfig all
>   [ full build ]
> $ cd ..
> $ mkdir baz
> $ move linux baz
> $ cd baz/linux
> $ make O=foo/bar
>   [ much faster re-build ]

I now noticed that the patch unconditionally recreates the symlink on
every make O= invocation. While this nicely fixes the problem with moved
build directory, it also means that a 'make O=... modules_install' ran
as root will try to recreate the symlink. This will fail on nfs. So I'd
rather keep the current logic with $(SRCTREE) containing either an
absolute or relative path.

Michal
