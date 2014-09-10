Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaIJXgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:36:50 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37271 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbaIJXgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:36:48 -0400
Message-ID: <1410392204.5187.14.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 2/6] KEYS: Reinstate EPERM for a key type name beginning
 with a '.'
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: jmorris@namei.org, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 10 Sep 2014 19:36:44 -0400
In-Reply-To: <20140910212206.10752.21818.stgit@warthog.procyon.org.uk>
References: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
	 <20140910212206.10752.21818.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091023-0928-0000-0000-000004C99CF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 22:22 +0100, David Howells wrote: 
> Reinstate the generation of EPERM for a key type name beginning with a '.' in
> a userspace call.  Types whose name begins with a '.' are internal only.
> 
> The test was removed by:
> 
> 	commit a4e3b8d79a5c6d40f4a9703abf7fe3abcc6c3b8d
> 	Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
> 	Date:   Thu May 22 14:02:23 2014 -0400
> 	Subject: KEYS: special dot prefixed keyring name bug fix
> 

The test was removed, as the patch log description indicates, because
the comparison is against the wrong field.  Even the function name
indicates key_get_type_from_user() is about the key type, not the key or
keyring name.

Debugging info:

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index e26f860..7a8d9b9 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -37,6 +37,7 @@ static int key_get_type_from_user(char *type,
                return ret;
        if (ret == 0 || ret >= len)
                return -EINVAL;
+       printk(KERN_INFO "%s: type %s \n", __func__, type);
        type[len - 1] = '\0';
        return 0;
}

: [    7.725429]: key_get_type_from_user: type trusted 
: [    9.007721] key_get_type_from_user: type keyring 
: [    9.011889] key_get_type_from_user: type keyring 
: [    9.068825] key_get_type_from_user: type encrypted 
: [    9.268310] key_get_type_from_user: type asymmetric 
: [    9.290360] key_get_type_from_user: type keyring 
: [    9.354509] key_get_type_from_user: type asymmetric 
: [    9.390396] key_get_type_from_user: type asymmetric 
: [    9.414216] key_get_type_from_user: type asymmetric 
: [    9.437155] key_get_type_from_user: type asymmetric 


> I think we want to keep the restriction on type name so that userspace can't
> add keys of a special internal type.

Definitely!  Commit a4e3b8d7 added a comparison against the description.

> Note that removal of the test causes several of the tests in the keyutils
> testsuite to fail.

Perhaps the added description test is insufficient, but reverting this
commit won't resolve the underlying problem.

Mimi

> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
> 
>  security/keys/keyctl.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> index e26f860e5f2e..eff88a5f5d40 100644
> --- a/security/keys/keyctl.c
> +++ b/security/keys/keyctl.c
> @@ -37,6 +37,8 @@ static int key_get_type_from_user(char *type,
>  		return ret;
>  	if (ret == 0 || ret >= len)
>  		return -EINVAL;
> +	if (type[0] == '.')
> +		return -EPERM;
>  	type[len - 1] = '\0';
>  	return 0;
>  }
> 


