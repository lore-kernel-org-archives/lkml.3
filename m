Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaFFWAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 18:00:39 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:60609 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaFFWAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 18:00:37 -0400
Message-ID: <1402092031.11626.35.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC PATCH v5 1/4] KEYS: special dot prefixed keyring name bug
 fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 06 Jun 2014 18:00:31 -0400
In-Reply-To: <CACE9dm909SGRBOybkh8z8jNiGPc_ksKHzsMuvNB+ro9furQ_tQ@mail.gmail.com>
References: <1401818318-15780-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1401818318-15780-2-git-send-email-zohar@linux.vnet.ibm.com>
	 <CACE9dm909SGRBOybkh8z8jNiGPc_ksKHzsMuvNB+ro9furQ_tQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060622-1344-0000-0000-0000020F6E21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-07 at 00:48 +0300, Dmitry Kasatkin wrote: 
> On 3 June 2014 20:58, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > Dot prefixed keyring names are supposed to be reserved for the
> > kernel, but add_key() calls key_get_type_from_user(), which
> > incorrectly verifies the 'type' field, not the 'description' field.
> > This patch verifies the 'description' field isn't dot prefixed,
> > when creating a new keyring, and removes the dot prefix test in
> > key_get_type_from_user().
> >
> > Changelog v5:
> > - Only prevent userspace from creating a dot prefixed keyring, not
> >   regular keys  - Dmitry
> >
> > Reported-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> > Cc: David Howells <dhowells@redhat.com>
> > Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > ---
> >  security/keys/keyctl.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> > index cd5bd0c..62a9952 100644
> > --- a/security/keys/keyctl.c
> > +++ b/security/keys/keyctl.c
> > @@ -37,8 +37,6 @@ static int key_get_type_from_user(char *type,
> >                 return ret;
> >         if (ret == 0 || ret >= len)
> >                 return -EINVAL;
> > -       if (type[0] == '.')
> > -               return -EPERM;
> >         type[len - 1] = '\0';
> >         return 0;
> >  }
> > @@ -86,6 +84,10 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
> >                 if (!*description) {
> >                         kfree(description);
> >                         description = NULL;
> > +               } else if ((description[0] == '.') &&
> > +                          (strncmp(type, "keyring", 7) == 0)) {
> > +                               ret = -EPERM;
> > +                               goto error2;
> >                 }
> >         }

> I think it does not another problem...
> It is not only prevent creating new keyring with ".abc" name but also
> prevent adding new key...
> 
> this is wrong...

Seems to prevent creating a dot prefixed keyring, but permits creating a
dot prefixed key.  Do you have an example?

thanks,

Mimi

Mimi


