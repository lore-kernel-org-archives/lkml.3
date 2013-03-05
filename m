Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab3CEBVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:21:38 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59015 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758950Ab3CEBVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:21:37 -0500
Message-ID: <1362446491.4392.133.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Date: Mon, 04 Mar 2013 20:21:31 -0500
In-Reply-To: <20130304191546.GF15199@redhat.com>
References: <CACLa4pum7kXK+7+8ceVSuQsKDCFebdgGVYRTMKH9GQarqCEgMQ@mail.gmail.com>
	 <1362102544.9158.35.camel@falcor1> <1362140107.9158.101.camel@falcor1>
	 <20130301152839.GA3457@redhat.com> <20130301184027.GB3457@redhat.com>
	 <1362166753.9158.169.camel@falcor1> <20130301213329.GC3457@redhat.com>
	 <1362346944.18325.1.camel@falcor1> <20130304152919.GA15199@redhat.com>
	 <1362423581.4392.46.camel@falcor1> <20130304191546.GF15199@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030501-3620-0000-0000-00000178FB70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 14:15 -0500, Vivek Goyal wrote:

> I am just brain storming and throwing some ideas and see if soemthing
> makes sense. I agree that allowing one policy only makes it very
> restrictive (while simplifying the implementation).

Agreed, lets try again ...  I think we are actually getting closer.

Without the memory locking or caching issues, would you agree that both
the builtin 'secureboot' and the 'ima_appraise_tcb' policies meet the
secure boot needs?   If both policies are acceptable, then we could
define the builtin 'secureboot' policy as the default policy, which
could be replaced with the 'ima_appraise_tcb' policy, if specified on
the boot command line.  This would eliminate any need for merging of
rules or rule flags.

To address the memory locking and caching issues, we could define a new
extended attribute type called IMA_XATTR_SECURE_BOOT.

enum evm_ima_xattr_type {
        IMA_XATTR_DIGEST = 0x01,
        EVM_XATTR_HMAC,
        EVM_IMA_XATTR_DIGSIG,
};

and set a corresponding flag in iint->flags.  The flag could then be the
bases for setting up any special secureboot requirements, like memory
locking and no caching. 

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index ddeadc7..6ec1575 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -172,6 +172,8 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 		}
 		status = INTEGRITY_PASS;
 		break;
+	case IMA_XATTR_SECURE_BOOT:
+		iint->flags |= IMA_SB;
 	case EVM_IMA_XATTR_DIGSIG:
 		iint->flags |= IMA_DIGSIG;
 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,

As originally intended, the policy defines which files are appraised,
not how they are appraised.  The extended attribute defines how the file
is to be appraised.

thanks,

Mimi

