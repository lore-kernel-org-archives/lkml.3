Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab3KRGSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 01:18:32 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53861 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3KRGS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 01:18:26 -0500
MIME-Version: 1.0
In-Reply-To: <20131118043515.GA3971@kroah.com>
References: <20131115041324.GA28088@kroah.com> <CEAC98F3.818F1%andreas.dilger@intel.com>
 <20131116195001.GA9308@kroah.com> <CA+a=Yy7SSKHM7O8DLnZfQQEQH5uUYH_gfWrg+Sc9eotQGdOsww@mail.gmail.com>
 <20131118043515.GA3971@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Mon, 18 Nov 2013 14:18:04 +0800
Message-ID: <CA+a=Yy6YwLYkUuV_0JB89UoZRimC78-kULFpKtzCQ_dBuAMeiA@mail.gmail.com>
Subject: Re: [PATCH 05/40] staging/lustre: validate open handle cookies
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hammond, John" <john.hammond@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 12:35 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Nov 18, 2013 at 10:36:26AM +0800, Peng Tao wrote:
>> On Sun, Nov 17, 2013 at 3:50 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Sat, Nov 16, 2013 at 11:20:37AM +0000, Dilger, Andreas wrote:
>> >> On 2013/11/14 9:13 PM, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
>> >> wrote:
>> >>
>> >> >On Fri, Nov 15, 2013 at 12:13:07AM +0800, Peng Tao wrote:
>> >> >> From: "John L. Hammond" <john.hammond@intel.com>
>> >> >>
>> >> >> Add a const void *h_owner member to struct portals_handle. Add a const
>> >> >> void *owner parameter to class_handle2object() which must be matched
>> >> >> by the h_owner member of the handle in addition to the cookie.
>> >> >
>> >> >Ick ick ick.
>> >> >
>> >> >NEVER use a void pointer if you can help it, and for a "handle", never.
>> >> >This isn't other operating systems, sorry.  We know what types our
>> >> >pointers to structures are, use them, so that the compiler can catch our
>> >> >problems, and don't try to cheat by using void *.
>> >>
>> >> The portals_handle is used as a generic type for objects referenced over
>> >> the network, like a file handle.  The "owner" parameter is just used as
>> >> an extra check that the cookie passed from the client is actually a
>> >> valid value for the code in which it is being used (e.g. metadata or
>> >> data object).  It isn't actually dereferenced by anything, it is just
>> >> like a magic value.
>> >
>> > Then make it an explicit type, not a void *.
>> >
>> >> >> Adjust
>> >> >> the callers of class_handle2object() accordingly, using NULL as the
>> >> >> argument to the owner parameter, except in the case of
>> >> >> mdt_handle2mfd() where we add an explicit mdt_export_data parameter
>> >> >> which we use as the owner when searching for a MFD. When allocating a
>> >> >> new MFD, pass a pointer to the mdt_export_data into mdt_mfd_new() and
>> >> >> store it in h_owner. This allows the MDT to validate that the client
>> >> >> has not sent the wrong open handle cookie, or sent the right cookie to
>> >> >> the wrong MDT.
>> >> >
>> >> >This changelog entry doesn't even match up with the code below.  ALl
>> >> >callers of class_handle2object are passing NULL here, which makes this
>> >> >patch pretty pointless, right?
>> >>
>> >> As Tao wrote, this is the patch summary that matches what was committed
>> >> in our own tree and in this case mostly describes the changes made on the
>> >> server.  Keeping the same commits and comments in both trees makes it
>> >> easier to keep the code in sync.
>> >
>> > Ok, but as it is, this patch does nothing to the client code, so how can
>> > I accept it?  A function that is only ever called with NULL as an option
>> > is ripe for cleanup in my eyes.
>> >
>> How about adding a comment above the function to note that this extra
>> argument is used by server code and please don't remove it?
>
> How about adding the server code to the kernel to keep problems like
> this (which will continue to crop up, it's not just this one function,
> right?) from happening in the future?
>
As explained in the other thread, the server code is not even ready
for landing in upstream kernel. And it won't be for quite some time.

> In-kernel code does not depend on out-of-kernel code, it's that simple,
> and has been a rule for kernel code for forever.  Either deal with the
> fact that you will have to keep the apis and functions working for your
> out-of-tree code, or put all the code into the kernel.  Don't force
> in-kernel code to deal with out-of-tree code as there is NO way that
> anyone other than the very few of you, can deal with that at all.
>
Fair enough. Andreas, how about we handling this kind of difference in
external tree and letting in-tree client be clean of it? We already
have HAVE_SERVER_SUPPORT macro in external tree. It is just a matter
of adding more references.

Thanks,
Tao
