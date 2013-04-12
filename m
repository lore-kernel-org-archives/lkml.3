Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3DLXrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:47:53 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:39050 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3DLXrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:47:52 -0400
MIME-Version: 1.0
In-Reply-To: <1365805938-22826-1-git-send-email-anatol.pomozov@gmail.com>
References: <1365805938-22826-1-git-send-email-anatol.pomozov@gmail.com>
Date: Fri, 12 Apr 2013 16:47:50 -0700
X-Google-Sender-Auth: 4LhBMbU0Ey_wZTsrlvtcsjo6uME
Message-ID: <CA+55aFzxxGBU3AOeNg3UEicHrx3nzWRyo5DOd=hh6SHJfYvB3g@mail.gmail.com>
Subject: Re: [PATCH] module: Fix race condition between load and unload module
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Salman Qazi <sqazi@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: multipart/mixed; boundary=14dae9cdcad7f5595404da32870f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9cdcad7f5595404da32870f
Content-Type: text/plain; charset=UTF-8

On Fri, Apr 12, 2013 at 3:32 PM, Anatol Pomozov
<anatol.pomozov@gmail.com> wrote:
>
> Here is timeline for the crash in case if kset_find_obj() searches for
> an object tht nobody holds and other thread is doing kobject_put()
> on the same kobject:
>
> THREAD A (calls kset_find_obj())     THREAD B (calls kobject_put())
> splin_lock()
>                                      atomic_dec_return(kobj->kref), counter gets zero here
>                                      ... starts kobject cleanup ....
>                                      spin_lock() // WAIT thread A in kobj_kset_leave()
> iterate over kset->list
> atomic_inc(kobj->kref) (counter becomes 1)
> spin_unlock()
>                                      spin_lock() // taken
>                                      // it does not know that thread A increased counter so it
>                                      remove obj from list
>                                      spin_unlock()
>                                      vfree(module) // frees module object with containing kobj
>
> // kobj points to freed memory area!!
> koubject_put(kobj) // OOPS!!!!

This is a much more generic bug in kobjects, and I would hate to add
some random workaround for just one case of this bug like you do. The
more fundamental bug needs to be fixed too.

I think the more fundamental bugfix is to just fix kobject_get() to
return NULL if the refcount was zero, because in that case the kobject
no longer really exists.

So instead of having

    kref_get(&kobj->kref);

it should do

    if (!atomic_inc_not_zero(&kobj->kref.refcount))
        kobj = NULL;

and I think that should fix your race automatically, no? Proper patch
attached (but TOTALLY UNTESTED - it seems to compile, though).

The problem is that we lose the warning for when the refcount is zero
and somebody does a kobject_get(), but that is ok *assuming* that
people actually check the return value of kobject_get() rather than
just "know" that if they passed in a non-NULL kobj, they'll get it
right back.

Greg - please take a look... I'm adding Al to the discussion too,
because Al just *loooves* these kinds of races ;)

                  Linus

--14dae9cdcad7f5595404da32870f
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfg09qa70

IGxpYi9rb2JqZWN0LmMgfCAzICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2xpYi9rb2JqZWN0LmMgYi9saWIva29iamVjdC5j
CmluZGV4IGUwN2VlMWZjZDZmMS4uOGQzNWZhMGQyYzE1IDEwMDY0NAotLS0gYS9saWIva29iamVj
dC5jCisrKyBiL2xpYi9rb2JqZWN0LmMKQEAgLTUyNSw3ICs1MjUsOCBAQCB2b2lkIGtvYmplY3Rf
ZGVsKHN0cnVjdCBrb2JqZWN0ICprb2JqKQogc3RydWN0IGtvYmplY3QgKmtvYmplY3RfZ2V0KHN0
cnVjdCBrb2JqZWN0ICprb2JqKQogewogCWlmIChrb2JqKQotCQlrcmVmX2dldCgma29iai0+a3Jl
Zik7CisJCWlmICghYXRvbWljX2luY19ub3RfemVybygma29iai0+a3JlZi5yZWZjb3VudCkpCisJ
CQlrb2JqID0gTlVMTDsKIAlyZXR1cm4ga29iajsKIH0KIAo=
--14dae9cdcad7f5595404da32870f--
