Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477AbaFIQdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:33:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45721 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbaFIQdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:33:40 -0400
Message-ID: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC PATCH v5 4/4] KEYS: define an owner trusted keyring
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 09 Jun 2014 12:33:34 -0400
In-Reply-To: <CACE9dm8C6Z8QkU=q6NnyTMYv91cTs5eH2WoALOo0ONtiTGCTnA@mail.gmail.com>
References: <1401818318-15780-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1401818318-15780-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <5395A4F9.1020205@samsung.com>
	 <1402318294.7064.19.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <5395B125.8010503@samsung.com>
	 <1402321691.7064.31.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CACE9dm8VNFa5Hf2po1kYgAhnfJC7eZGp67-MDc1t66vg6HVYTQ@mail.gmail.com>
	 <CACE9dm8C6Z8QkU=q6NnyTMYv91cTs5eH2WoALOo0ONtiTGCTnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060916-6688-0000-0000-00000271BF81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2014-06-09 at 17:06 +0300, Dmitry Kasatkin wrote:
> On 9 June 2014 16:58, Dmitry Kasatkin <dmitry.kasatkin@gmail.com> wrote:
> > On 9 June 2014 16:48, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >> On Mon, 2014-06-09 at 16:05 +0300, Dmitry Kasatkin wrote:
> >>> On 09/06/14 15:51, Mimi Zohar wrote:
> >>> > On Mon, 2014-06-09 at 15:13 +0300, Dmitry Kasatkin wrote:
> >>> >> On 03/06/14 20:58, Mimi Zohar wrote:
> >>> >>> Instead of allowing public keys, with certificates signed by any
> >>> >>> key on the system trusted keyring, to be added to a trusted
> >>> >>> keyring, this patch further restricts the certificates to those
> >>> >>> signed by a particular key on the system keyring.
> >>> >>>
> >>> >>> When the UEFI secure boot keys are added to the system keyring, the
> >>> >>> platform owner will be able to load their key in one of the UEFI DBs
> >>> >>> (eg. Machine Owner Key(MOK) list) and select their key, without
> >>> >>> having to rebuild the kernel.
> >>> >>>
> >>> >>> This patch defines an owner trusted keyring, a new boot command
> >>> >>> line option 'keys_ownerid=', and defines a new function
> >>> >>> get_system_or_owner_trusted_keyring().
> >>> >> Hello,
> >>> >>
> >>> >> The functionality of this entire patch can be replaced by only ~2 lines
> >>> >> of code in x509_request_asymmetric_key()
> >>> >>
> >>> >> if (keys_ownerid || strcmp(keys_ownerid, id))
> >>> >>      return -EPERM;
> >>> >>
> >>> >> Right?
> >>> > Are you suggesting only add the one matching key to the system keyring?
> >>>
> >>> No. I am not suggesting this.
> >>>
> >>> All built in keys are allocated with KEY_ALLOC_TRUSTED flag and
> >>> prep.trusted is set to "true".
> >>>
> >>> So  the following statement has no effect.
> >>
> >> Ok, so it has no affect on adding builtin keys to the system keyring.
> >>
> >>>
> >>> #ifdef CONFIG_SYSTEM_TRUSTED_KEYRING
> >>>         ret = x509_validate_trust(cert, system_trusted_keyring);
> >>>         if (!ret)
> >>>             prep->trusted = 1;
> >>> #endif
> >>
> >> The last patch set changes the test to:
> >>      ret = x509_validate_trust(cert, get_system_or_owner_trusted_keyring());
> >>
> >
> > It does not really mater. I just copied original code to my response.
> >
> >>> Keys which come from user-space will check for
> >>>
> >>> if (keys_ownerid && strcmp(keys_ownerid, id))
> >>>      return -EPERM;
> >>>
> >>>
> >>> So 2 lines patch works fine..
> >>
> >> It works based on the assumption, that you would ever only want a single
> >> key on the 'owner' keyring, which is probably not the case.
> >>
> >
> > There is no any assumption here. I am discussing functionality of this patch.
> > That is exactly what this patch does - loads single key on the owners keyring.
> >
> > There is no need for additional keyring for a single key. That is just
> > enough to limit verification to the owners key id.
> >
> 
> There is no reason to have advanced bloated implementation for unsure,
> may be never coming use-cases.
> 
> It is always very easy to make new patches for the future cases.

Normally I would agree with you, but in this case we already have
multiple use case scenarios (eg. builtin keys, transitioning from one
MOK key to another), but are simply waiting for the proposed UEFI key
patches to be upstreamed.  Basically, we need the UEFI key patches
functionality, if not these specific patches, to safely identify the
owner's key(s), without requiring the end user to rebuild the kernel to
include their key(s).

Mimi

