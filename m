Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935756Ab3DJTnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:43:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934797Ab3DJTnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:43:22 -0400
Date: Wed, 10 Apr 2013 15:42:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Josh Boyer <jwboyer@gmail.com>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] initramfs with digital signature protection
Message-ID: <20130410194209.GF6602@redhat.com>
References: <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
 <20130205181926.GA13942@srcf.ucam.org>
 <20130205183436.GC12853@redhat.com>
 <CALLzPKavbsZgHoJrk5iQ0F1fO21SaeEHmCVCh1G1UKCKB3WZZQ@mail.gmail.com>
 <20130405135000.GB6299@redhat.com>
 <1365450229.3847.56.camel@falcor1.watson.ibm.com>
 <20130408200904.GI28292@redhat.com>
 <CA+5PVA43U_kDSV7p0zhQwmK9pwbVb8qAUePU8svQvoPbDA9iCQ@mail.gmail.com>
 <20130409143852.GH6320@redhat.com>
 <1365563230.3074.107.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365563230.3074.107.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:07:10PM -0400, Mimi Zohar wrote:

[..]
> The module keyring is a special case.  Loading these keys from the
> kernel and, presumably, locking the keyring is probably fine.  In the
> case of IMA, however, files will be signed by any number of package
> owners.  If the _ima keyring is locked by the kernel, how would you add
> these other keys?

Who are package owners here. IOW, in typical IMA setup, where are the keys
and when are these keys loaded in ima keyring?

If we trust root and keys can be loaded any time later, then signed
initramfs will not solve the problem either.

So this boils down to again not trusting root. So secureboot will not
trust root and IMA does. 

May be we need an additional IMA keyring which gets locked by kernel
(like module keyring). And during signing, we need to encode keyring
info in file signatuer. IMA will parse keyring info and try to verify
signature against that specified keyring.

/sbin/kexec signing can happen in such a way that we tell IMA to verify
against this locked keyring say, ima_kernel.

And in regular ima keyring, root can continue to load its own keys in
usual way even in secureboot mode.

Just that sys_kexec() will have to call into IMA to make sure that
/sbin/kexec's integrity was verified using keys in ima_kernel keyring 
and not using keys in _ima keyring.

IOW, apart from integrity results, we will have to store the keyring
info too in results which should be queryable by the client. And then
client can decide how to interpret integrity results.

Or we can just export the APIs from IMA (which don't do any caching) and
client can specify keyring to verify against as a parameter.

Thoughts?

Thanks
Vivek
