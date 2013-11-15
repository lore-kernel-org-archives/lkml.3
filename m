Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab3KOKX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:23:27 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51479 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3KOKXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:23:18 -0500
MIME-Version: 1.0
In-Reply-To: <20131115041324.GA28088@kroah.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
 <1384445622-12346-6-git-send-email-bergwolf@gmail.com> <20131115041324.GA28088@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Fri, 15 Nov 2013 18:22:57 +0800
Message-ID: <CA+a=Yy6=Qx+bT4cHx9WwzcB1S4JaSehcW3T=A9Uf6Aity09doA@mail.gmail.com>
Subject: Re: [PATCH 05/40] staging/lustre: validate open handle cookies
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:13 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Nov 15, 2013 at 12:13:07AM +0800, Peng Tao wrote:
>> From: "John L. Hammond" <john.hammond@intel.com>
>>
>> Add a const void *h_owner member to struct portals_handle. Add a const
>> void *owner parameter to class_handle2object() which must be matched
>> by the h_owner member of the handle in addition to the cookie.
>
> Ick ick ick.
>
> NEVER use a void pointer if you can help it, and for a "handle", never.
> This isn't other operating systems, sorry.  We know what types our
> pointers to structures are, use them, so that the compiler can catch our
> problems, and don't try to cheat by using void *.
>
Here the void * is not used to pass any structures. It just intends to
save any pointer that is viewed as owner of the handle. Does it make
sense?

Maybe we can just make it unsigned long and type cast the owner
pointer to unsigned long as well. But I guess that is even more
hacky...

>> Adjust
>> the callers of class_handle2object() accordingly, using NULL as the
>> argument to the owner parameter, except in the case of
>> mdt_handle2mfd() where we add an explicit mdt_export_data parameter
>> which we use as the owner when searching for a MFD. When allocating a
>> new MFD, pass a pointer to the mdt_export_data into mdt_mfd_new() and
>> store it in h_owner. This allows the MDT to validate that the client
>> has not sent the wrong open handle cookie, or sent the right cookie to
>> the wrong MDT.
>
> This changelog entry doesn't even match up with the code below.  ALl
> callers of class_handle2object are passing NULL here, which makes this
> patch pretty pointless, right?
>
The extra pointer argument is in fact used by server code. The
function is shared by client and server and we want to keep it sync in
the two places.

> And that's a _very_ generic global symbol name, please don't do that, it
> needs to be "lustre_*" at the front to even expect it to be acceptable.
>
OK. I'll rename it.

Thanks,
Tao
