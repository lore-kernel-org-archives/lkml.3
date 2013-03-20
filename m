Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825Ab3CTBCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:02:18 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42036 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679Ab3CTBCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:02:17 -0400
MIME-Version: 1.0
In-Reply-To: <51489242.9020801@gmail.com>
References: <20130307052854.GA23745@redhat.com>
	<20130307060230.GA31738@kroah.com>
	<20130307062626.GA25095@redhat.com>
	<51429D7A.30906@gmail.com>
	<5142ABD3.4040106@gmail.com>
	<CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com>
	<CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com>
	<51448AC9.7080105@gmail.com>
	<CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com>
	<CACVXFVNCGBAYLbbpE1sBiXFNkJpRxVzY44y3Vok+GA9C0MKr3w@mail.gmail.com>
	<5144BB15.3020002@gmail.com>
	<CACVXFVOKi=wKsLP850XJ95P=e1B2z+CP=t0GATCZL0gNDOCwnA@mail.gmail.com>
	<5145D236.70203@gmail.com>
	<CACVXFVP7XHO8sT68ETam=R-+cbPjSGqz_xfnt30OiSPEuC4-Sg@mail.gmail.com>
	<5147C821.6070703@gmail.com>
	<CACVXFVNMtY5tvAvyqyAyYRwBzfTtZKkDambDUTUNYwd0Q3XkXA@mail.gmail.com>
	<CACVXFVPV3mq=k-AZ1bYkAMdxwXD96Ty7DYeh9H9J=yvA4m=rGA@mail.gmail.com>
	<51489242.9020801@gmail.com>
Date: Wed, 20 Mar 2013 09:02:15 +0800
Message-ID: <CACVXFVN8EDMgHyshxX41er463rMsbUSrzs9pX17NdDg4PVHSvw@mail.gmail.com>
Subject: Re: use after free in sysfs_find_dirent
From: Ming Lei <tom.leiming@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=14dae9cdc787e947ae04d850c568
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9cdc787e947ae04d850c568
Content-Type: text/plain; charset=ISO-8859-1

Hi Sasha,

On Wed, Mar 20, 2013 at 12:28 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On 03/19/2013 07:54 AM, Ming Lei wrote:
>
> With v3 of the patch:
>
> [ 1275.665758] sysfs_dir_pos-973 sysfs_dirent use after free: tun(tun)-uevent, 2-1472641949

Thanks again for your test.

Looks it is caused by another bug in sysfs_readdir:  if filldir() returns
failure(such as small buffer length passed from userspace, very probably
for trinity) in case of 'if (filp->f_pos ==  0 or 1)',
filp->private_data still will
point to one refcount-balanced sysfs_dirent object.

V4 adds fix for this situation, please test attachment v4 patch.

Thanks,
-- 
Ming Lei

--14dae9cdc787e947ae04d850c568
Content-Type: application/octet-stream; name="sysfs-fix-readdir-v4.patch"
Content-Disposition: attachment; filename="sysfs-fix-readdir-v4.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hehs6wrc0

ZGlmZiAtLWdpdCBhL2ZzL3N5c2ZzL2Rpci5jIGIvZnMvc3lzZnMvZGlyLmMKaW5kZXggMmZiZGZm
Ni4uMDE0ZWQ5NyAxMDA2NDQKLS0tIGEvZnMvc3lzZnMvZGlyLmMKKysrIGIvZnMvc3lzZnMvZGly
LmMKQEAgLTI4MCw2ICsyODAsMTEgQEAgdm9pZCByZWxlYXNlX3N5c2ZzX2RpcmVudChzdHJ1Y3Qg
c3lzZnNfZGlyZW50ICogc2QpCiAJICogc2QtPnNfcGFyZW50IHdvbid0IGNoYW5nZSBiZW5lYXRo
IHVzLgogCSAqLwogCXBhcmVudF9zZCA9IHNkLT5zX3BhcmVudDsKKwlpZighKHNkLT5zX2ZsYWdz
ICYgU1lTRlNfRkxBR19SRU1PVkVEKSkgeworCQlwcmludGsoIiVzLSVkIHN5c2ZzX2RpcmVudCB1
c2UgYWZ0ZXIgZnJlZTogJXMtJXNcbiIsCisJCQlfX2Z1bmNfXywgX19MSU5FX18sIHBhcmVudF9z
ZC0+c19uYW1lLCBzZC0+c19uYW1lKTsKKwkJZHVtcF9zdGFjaygpOworCX0KIAogCWlmIChzeXNm
c190eXBlKHNkKSA9PSBTWVNGU19LT0JKX0xJTkspCiAJCXN5c2ZzX3B1dChzZC0+c19zeW1saW5r
LnRhcmdldF9zZCk7CkBAIC05NjIsNiArOTY3LDEyIEBAIHN0YXRpYyBzdHJ1Y3Qgc3lzZnNfZGly
ZW50ICpzeXNmc19kaXJfcG9zKGNvbnN0IHZvaWQgKm5zLAogCQlpbnQgdmFsaWQgPSAhKHBvcy0+
c19mbGFncyAmIFNZU0ZTX0ZMQUdfUkVNT1ZFRCkgJiYKIAkJCXBvcy0+c19wYXJlbnQgPT0gcGFy
ZW50X3NkICYmCiAJCQloYXNoID09IHBvcy0+c19oYXNoOworCisJCWlmICgoYXRvbWljX3JlYWQo
JnBvcy0+c19jb3VudCkgPT0gMSkpIHsKKwkJCXByaW50aygiJXMtJWQgc3lzZnNfZGlyZW50IHVz
ZSBhZnRlciBmcmVlOiAlcyglcyktJXMsICVsbGQtJXVcbiIsCisJCQkJX19mdW5jX18sIF9fTElO
RV9fLCBwYXJlbnRfc2QtPnNfbmFtZSwgcG9zLT5zX3BhcmVudC0+c19uYW1lLAorCQkJCXBvcy0+
c19uYW1lLCBoYXNoLCBwb3MtPnNfaGFzaCk7CisJCX0KIAkJc3lzZnNfcHV0KHBvcyk7CiAJCWlm
ICghdmFsaWQpCiAJCQlwb3MgPSBOVUxMOwpAQCAtMTAyMCw2ICsxMDMxLDggQEAgc3RhdGljIGlu
dCBzeXNmc19yZWFkZGlyKHN0cnVjdCBmaWxlICogZmlscCwgdm9pZCAqIGRpcmVudCwgZmlsbGRp
cl90IGZpbGxkaXIpCiAJCWlubyA9IHBhcmVudF9zZC0+c19pbm87CiAJCWlmIChmaWxsZGlyKGRp
cmVudCwgIi4iLCAxLCBmaWxwLT5mX3BvcywgaW5vLCBEVF9ESVIpID09IDApCiAJCQlmaWxwLT5m
X3BvcysrOworCQllbHNlCisJCQlyZXR1cm4gMDsKIAl9CiAJaWYgKGZpbHAtPmZfcG9zID09IDEp
IHsKIAkJaWYgKHBhcmVudF9zZC0+c19wYXJlbnQpCkBAIC0xMDI4LDYgKzEwNDEsOCBAQCBzdGF0
aWMgaW50IHN5c2ZzX3JlYWRkaXIoc3RydWN0IGZpbGUgKiBmaWxwLCB2b2lkICogZGlyZW50LCBm
aWxsZGlyX3QgZmlsbGRpcikKIAkJCWlubyA9IHBhcmVudF9zZC0+c19pbm87CiAJCWlmIChmaWxs
ZGlyKGRpcmVudCwgIi4uIiwgMiwgZmlscC0+Zl9wb3MsIGlubywgRFRfRElSKSA9PSAwKQogCQkJ
ZmlscC0+Zl9wb3MrKzsKKwkJZWxzZQorCQkJcmV0dXJuIDA7CiAJfQogCW11dGV4X2xvY2soJnN5
c2ZzX211dGV4KTsKIAlmb3IgKHBvcyA9IHN5c2ZzX2Rpcl9wb3MobnMsIHBhcmVudF9zZCwgZmls
cC0+Zl9wb3MsIHBvcyk7CkBAIC0xMDU4LDEwICsxMDczLDIxIEBAIHN0YXRpYyBpbnQgc3lzZnNf
cmVhZGRpcihzdHJ1Y3QgZmlsZSAqIGZpbHAsIHZvaWQgKiBkaXJlbnQsIGZpbGxkaXJfdCBmaWxs
ZGlyKQogCXJldHVybiAwOwogfQogCitzdGF0aWMgbG9mZl90IHN5c2ZzX2Rpcl9sbHNlZWsoc3Ry
dWN0IGZpbGUgKmZpbGUsIGxvZmZfdCBvZmZzZXQsIGludCB3aGVuY2UpCit7CisJc3RydWN0IGlu
b2RlICppbm9kZSA9IGZpbGVfaW5vZGUoZmlsZSk7CisJbG9mZl90IHJldDsKKworCW11dGV4X2xv
Y2soJmlub2RlLT5pX211dGV4KTsKKwlyZXQgPSBnZW5lcmljX2ZpbGVfbGxzZWVrKGZpbGUsIG9m
ZnNldCwgd2hlbmNlKTsKKwltdXRleF91bmxvY2soJmlub2RlLT5pX211dGV4KTsKKworCXJldHVy
biByZXQ7Cit9CiAKIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgc3lzZnNfZGlyX29wZXJh
dGlvbnMgPSB7CiAJLnJlYWQJCT0gZ2VuZXJpY19yZWFkX2RpciwKIAkucmVhZGRpcgk9IHN5c2Zz
X3JlYWRkaXIsCiAJLnJlbGVhc2UJPSBzeXNmc19kaXJfcmVsZWFzZSwKLQkubGxzZWVrCQk9IGdl
bmVyaWNfZmlsZV9sbHNlZWssCisJLmxsc2VlawkJPSBzeXNmc19kaXJfbGxzZWVrLAogfTsK
--14dae9cdc787e947ae04d850c568--
