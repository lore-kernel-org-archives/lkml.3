Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934455AbaE3UpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:45:05 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61816 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbaE3UpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:45:03 -0400
MIME-Version: 1.0
In-Reply-To: <1401477177.2295.4.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1401289784-31340-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1401289784-31340-2-git-send-email-zohar@linux.vnet.ibm.com>
	<CACE9dm8OMGH5V19iRkytPtQXt9qNha9Ca81P6dpy-cqE2s5NYg@mail.gmail.com>
	<1401472704.15365.4.camel@dhcp-9-2-203-236.watson.ibm.com>
	<CACE9dm-n4R9CSjfzpzCaYrSWDxCOsgX7w2Cvn4gkR6-Z82Qypg@mail.gmail.com>
	<1401477177.2295.4.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Fri, 30 May 2014 23:45:01 +0300
Message-ID: <CACE9dm-HnhtMTpGzkpAf+1dp4Yt=5nt6K=dVeJs6w0z+PjgHCw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/4] KEYS: special dot prefixed keyring name bug fix
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        keyrings <keyrings@linux-nfs.org>, Josh Boyer <jwboyer@redhat.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 May 2014 22:12, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Fri, 2014-05-30 at 21:24 +0300, Dmitry Kasatkin wrote:
>> On 30 May 2014 20:58, "Mimi Zohar" <zohar@linux.vnet.ibm.com> wrote:
>> >
>> > On Fri, 2014-05-30 at 18:58 +0300, Dmitry Kasatkin wrote:
>> > > On 28 May 2014 18:09, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> > > > Dot prefixed keyring names are supposed to be reserved for the
>> > > > kernel, but add_key() calls key_get_type_from_user(), which
>> > > > incorrectly verifies the 'type' field, not the 'description' field.
>> > > > This patch verifies the 'description' field isn't dot prefixed,
>> > > > when creating a new keyring, and removes the dot prefix test in
>> > > > key_get_type_from_user().
>> > > >
>> > > > Reported-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> > > > Cc: David Howells <dhowells@redhat.com>
>> > > > Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
>> > > > ---
>> > > >  security/keys/keyctl.c | 6 ++++--
>> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
>> > > >
>> > > > diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
>> > > > index cd5bd0c..9e9a762 100644
>> > > > --- a/security/keys/keyctl.c
>> > > > +++ b/security/keys/keyctl.c
>> > > > @@ -37,8 +37,6 @@ static int key_get_type_from_user(char *type,
>> > > >                 return ret;
>> > > >         if (ret == 0 || ret >= len)
>> > > >                 return -EINVAL;
>> > > > -       if (type[0] == '.')
>> > > > -               return -EPERM;
>> > > >         type[len - 1] = '\0';
>> > > >         return 0;
>> > > >  }
>> > > > @@ -87,6 +85,10 @@ SYSCALL_DEFINE5(add_key, const char __user *,
>> _type,
>> > > >                         kfree(description);
>> > > >                         description = NULL;
>> > > >                 }
>> > > > +               if (description[0] == '.') {
>> > > > +                       ret = -EPERM;
>> > > > +                       goto error2;
>> > > > +               }
>> > >
>> > > 1. 3 lines above "discription = NULL" will cause kernel oops...
>> > > It happens when using empty description... like:
>> > >
>> > > cat x509_ima.der | keyctl padd asymmetric "" keyid
>> >
>> > Right, that should be 'else if'.
>> >
>> > > 2. It prevents adding trusted keys to ".ima" from user space...
>> > > This is NOT what we want... right?
>> >
>> > It prevents creating a dot prefixed keyring.
>> >
>>
>> May be. But it prevents also adding the key....
>> It needs to distinguish key adding and keyring adding then...
>
> Perhaps, but assuming you created a keyring on @u, you would still need
> to look up the keyid and use it.  The same is true here.  Instead of
> using "keyctl search @u keyring _ima", you would use "keyctl describe %
> keyring:.ima".  The first field is the keyring id.
>
> Mimi
>

Not perhaps, but for sure.
In the case of adding the key, "description" is not a keyring name...
it is a key name.
In the case of adding keyring, "description" is a keyring name...

- Dmitry

-- 
Thanks,
Dmitry
