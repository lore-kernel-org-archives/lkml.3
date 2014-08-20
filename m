Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaHTWRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 18:17:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:4714 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbaHTWRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 18:17:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,905,1400050800"; 
   d="p7s'?scan'208";a="470951177"
From: "Woodhouse, David" <david.woodhouse@intel.com>
To: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
CC: "arjun024@gmail.com" <arjun024@gmail.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] params: fix potential memory leak in add_sysfs_param()
Thread-Topic: [PATCH] params: fix potential memory leak in add_sysfs_param()
Thread-Index: AQHPvLhzbjOa66bTlUaeAE0XC3Z8JJvZ64eAgAAP/oCAAANpAA==
Date: Wed, 20 Aug 2014 22:17:48 +0000
Message-ID: <1408573066.9484.11.camel@intel.com>
References: <1408564816-1778-1-git-send-email-arjun024@gmail.com>
	 <87mwayj39c.fsf@rustcorp.com.au>
	 <CAJFMrCG1OXrdRoUNqtZYdBqE_0dj+a3yAfFhuyFvTte7Ozbo0w@mail.gmail.com>
	 <87ha16izpu.fsf@rustcorp.com.au>
In-Reply-To: <87ha16izpu.fsf@rustcorp.com.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.76.103]
Content-Type: multipart/signed; micalg=sha-1;
	protocol="application/x-pkcs7-signature"; boundary="=-PJJ76wdLe/XmwH0d8QuY"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-PJJ76wdLe/XmwH0d8QuY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-08-21 at 07:35 +0930, Rusty Russell wrote:
>=20
> Above this:
>         if (!mk->mp) {
>                 num =3D 0;
>                 attrs =3D NULL;
>         } else {
>                 num =3D mk->mp->num;
>                 attrs =3D mk->mp->grp.attrs;
>         }
>=20
> So, attrs is just a temporary: either NULL (doesn't need freeing), or
> is the old mk->mp->grp.attrs ptr.

Except that in the failure case we *free* the old mk->mp and never free
mk->mp->grp.attrs so it *is* indeed lost.

A simpler version of Arjun's patch might look like this:

diff --git a/kernel/params.c b/kernel/params.c
index 34f5270..f9459bc 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -613,7 +613,6 @@ static __modinit int add_sysfs_param(struct module_kobj=
ect *mk,
 		       sizeof(*mk->mp) + sizeof(mk->mp->attrs[0]) * (num+1),
 		       GFP_KERNEL);
 	if (!new) {
-		kfree(attrs);
 		err =3D -ENOMEM;
 		goto fail;
 	}
@@ -653,7 +652,10 @@ static __modinit int add_sysfs_param(struct module_kob=
ject *mk,
 fail_free_new:
 	kfree(new);
 fail:
-	mk->mp =3D NULL;
+	if (mk->mp) {
+		kfree(mk->mp->grp.attrs);
+		mk->mp =3D NULL;
+	}
 	return err;
 }
=20


But as I suggested in my previous response, a *better* fix might look
like this:

diff --git a/kernel/params.c b/kernel/params.c
index 34f5270..cdab9d4 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -595,7 +595,7 @@ static __modinit int add_sysfs_param(struct module_kobj=
ect *mk,
 {
 	struct module_param_attrs *new;
 	struct attribute **attrs;
-	int err, num;
+	int num;
=20
 	/* We don't bother calling this with invisible parameters. */
 	BUG_ON(!kp->perm);
@@ -612,18 +612,19 @@ static __modinit int add_sysfs_param(struct module_ko=
bject *mk,
 	new =3D krealloc(mk->mp,
 		       sizeof(*mk->mp) + sizeof(mk->mp->attrs[0]) * (num+1),
 		       GFP_KERNEL);
-	if (!new) {
-		kfree(attrs);
-		err =3D -ENOMEM;
-		goto fail;
-	}
+	if (!new)
+		return -ENOMEM;
+
 	/* Despite looking like the typical realloc() bug, this is safe.
-	 * We *want* the old 'attrs' to be freed either way, and we'll store
-	 * the new one in the success case. */
+	 * In the failure case, the old 'attrs' is still in new->grp.attrs
+	 * and will live on there. */
 	attrs =3D krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
 	if (!attrs) {
-		err =3D -ENOMEM;
-		goto fail_free_new;
+		/* This is in a larger kmalloc allocation than before but
+		 * otherwise entirely unchanged. We've failed to add the
+		 * new param but the existing ones are still there. */
+		mk->mp =3D new;
+		return -ENOMEM;
 	}
=20
 	/* Sysfs wants everything zeroed. */
@@ -649,12 +650,6 @@ static __modinit int add_sysfs_param(struct module_kob=
ject *mk,
=20
 	mk->mp =3D new;
 	return 0;
-
-fail_free_new:
-	kfree(new);
-fail:
-	mk->mp =3D NULL;
-	return err;
 }
=20
 #ifdef CONFIG_MODULES


--=20
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

--=-PJJ76wdLe/XmwH0d8QuY
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

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
kiW8/Nj6KITQvHqz7x/Es0IRJCc9/zBES7yMeD+fgJKHAEv/uTcFfGM9HIWxPQIDAQABo4IC6jCC
AuYwHQYDVR0OBBYEFGK1Mey+kPYGHowHJ0YXtQU4NmbSMB8GA1UdIwQYMBaAFB5pKrTcKP5HGE4h
Cz+8rBEv8Jj1MIHJBgNVHR8EgcEwgb4wgbuggbiggbWGVGh0dHA6Ly93d3cuaW50ZWwuY29tL3Jl
cG9zaXRvcnkvQ1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDRB
LmNybIZdaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50ZWwl
MjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3JsMIHvBggrBgEFBQcBAQSB
4jCB3zBpBggrBgEFBQcwAoZdaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZp
Y2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3J0MHIG
CCsGAQUFBzAChmZodHRwOi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRp
ZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjA0QS5jcnQw
CwYDVR0PBAQDAgeAMDwGCSsGAQQBgjcVBwQvMC0GJSsGAQQBgjcVCIbDjHWEmeVRg/2BKIWOn1OC
kcAJZ4HevTmV8EMCAWQCAQgwHwYDVR0lBBgwFgYIKwYBBQUHAwQGCisGAQQBgjcKAwwwKQYJKwYB
BAGCNxUKBBwwGjAKBggrBgEFBQcDBDAMBgorBgEEAYI3CgMMME8GA1UdEQRIMEagKQYKKwYBBAGC
NxQCA6AbDBlkYXZpZC53b29kaG91c2VAaW50ZWwuY29tgRlkYXZpZC53b29kaG91c2VAaW50ZWwu
Y29tMA0GCSqGSIb3DQEBBQUAA4IBAQBCQ4UH3yybC+PzPo7W4PQJQwIDkKfD2i20i/DosQ7+Yeof
KF7qDASe9eoJGXbINBx1u648uOnaMBsxgUUamJo7pdt1ZnsetRtCQrJIsrsJA3Q2MOsrv7xHkzqn
DF99KHEbO2yKvyjJVDznHUWh8M1OFmdoziyWE/VPdqTwXwS/UKO81XaTtWUDGO716HHVlfT9yPle
Ukg2MTcIhhNWmlS8gDUayhteIAlPci71f/oXzXxBiGiO6FVZUEx+rZBQB84Ey0S0Tfm7hiGzoegg
ra0hfiiMOKMio+n0r4NUn03Z+VRUTbdjHIA6Lkozwpadvs9/uK8dIGqfcgxYgk9qdjFPMYICDjCC
AgoCAQEwgYcweTELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRQwEgYDVQQHEwtTYW50YSBDbGFy
YTEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJh
c2ljIElzc3VpbmcgQ0EgNEECCmJiMmoAAAAATKAwCQYFKw4DAhoFAKBdMBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDgyMDIyMTc0NlowIwYJKoZIhvcNAQkEMRYE
FFqIFqYxnDn0H+LCZ+UpGOI0eKCkMA0GCSqGSIb3DQEBAQUABIIBAGeGFDQPeTsnFd9k+pZgQb+2
4x6xDXPFVCfCAK1gIufiXbJR2PwkkctkKHPfsuHe/dEWJIAkmV4NkVPSv2tEuvlFwO5O/kh14urK
VcmO531faucq2x9JZAug3/1HnFZKCh7CMh7niDoUnDjH+nymxO44rQ6VQShr4FQUop/FHwhKkuAT
BroqyOeaW2I9J7Auqd1UI6X7OXpTMCdhcF45GeX2ggn06UnzwiY5BJkTFnUIEg3WKnosf1ZU5klY
dXOG1r0RTHejyKHYeMj6qY1XK0R4fYPG6lkr5JID+9VEFUfiDK4xGC4/iuFyxG/dKrmChkIaJyLh
3b4vspeTPiItV8AAAAAAAAA=


--=-PJJ76wdLe/XmwH0d8QuY--
