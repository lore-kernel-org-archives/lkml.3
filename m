Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbaHZKcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:32:11 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:34942
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754236AbaHZKcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:32:08 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPvFjgvav2zR0lYke3SB9WxJlS05vhXWzggABBfwCAAQnBQA==
Date: Tue, 26 Aug 2014 10:30:54 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
References: <20140820092630.GA1478@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C994F314@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140825174132.GA17681@sucs.org>
In-Reply-To: <20140825174132.GA17681@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.96]
Content-Type: multipart/mixed;
	boundary="_002_EE124450C0AAF944A40DD71E61F878C995E93ESINEX14MBXC419sou_"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377454003)(51914003)(164054003)(51704005)(189002)(199003)(13464003)(87936001)(6806004)(81342001)(44976005)(16796002)(74502001)(68736004)(84326002)(110136001)(77982001)(76176999)(33656002)(19580395003)(64706001)(106116001)(69596002)(83072002)(31966008)(81156004)(83322001)(79102001)(568964001)(26826002)(95666004)(86612001)(20776003)(92566001)(80022001)(71186001)(512954002)(2656002)(86362001)(77096002)(84676001)(107046002)(106466001)(85852003)(55846006)(99936001)(97736001)(76482001)(54356999)(50986999)(74662001)(85306004)(21056001)(46102001)(15975445006)(99396002)(81542001)(4396001)(90102001)(92726001)(1411001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB578;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_EE124450C0AAF944A40DD71E61F878C995E93ESINEX14MBXC419sou_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Sitsofe Wheeler
> Sent: Tuesday, August 26, 2014 1:42 AM
> > > [    7.645526] hv_vmbus: registering driver hyperv_fb
> > > [    7.657553] BUG: unable to handle kernel paging request at
> > > ffff880077800004
> > > [    7.658224] IP: [<ffffffff8159a7ac>] hv_ringbuffer_write+0x7c/0x15=
0
> > > [    7.658224] PGD 2da9067 PUD 2dac067 PMD 7fa27067 PTE
> > > 8000000077800060
> > > [    7.658224] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> > It seems
> > hv_ringbuffer_write() ->
> >     hv_get_ringbuffer_availbytes():
> >         reading rbi->ring_buffer->read_index causes a page fault.
> >
> > It looks rbi->ring_buffer was unmapped somehow according to the
> > semantics of CONFIG_DEBUG_PAGEALLOC??? Or, was there a memory
> > corruption somewhere?
> >
> > It looks the panic will disappear if the guest isn't configured with a
> > "Network Adapter ".
IMO it has nothing to do with the hyperv netvsc, as here hypervfb is the fi=
rst
one to invoke vmbus_open(), and hyperv netvsc's vmbus_open() hasn't been
invoked.

> This sounds very fishy as if network setup has left things in a bad
> state.=20
Ditto. I doubt the network driver causes the issue.

> What is baffles me is the whole UP vs SMP thing - why would UP
> make this show up consistently? Perhaps some assertions could be added
> to check that rbi->ring_buffer still has sane values in it after
> operations on it are finished?
With more tests, I found vcpus=3D2 has the same issue, despite  a
small possibility.
vcpus=3D4 seems fine in my limited tests.

> I guess you could try switching things around and using
> kmemcheck (https://www.kernel.org/doc/Documentation/kmemcheck.txt ).
> If
> the whole area close to rbi->ring_buffer->read_index is being stomped on
> it should show up. If it's just being set to a duff value or freed that
> going to be harder to track down although poisoning before freeing
> should allow us to distinguish that case...
Thanks for the info.

Actually I found the direct cause of the panic:
sometimes vmbus_post_msg() can return 4 (HV_STATUS_INVALID_ALIGNMENT),
but vmbus_open() doesn't propagate this error to the caller
synthvid_connect_vsp(), and vmbus_open() " goto error1"  and frees the
ringbuffer! So later the access to ring_buffer->read_index is caught by
CONFIG_DEBUG_PAGEALLOC.

I don't see any "invalid alignment" here... and I can't explain why vcpus=
=3D4
seems OK... Debugging WIP.

BTW, please try the attached patch.
With it, the VM doesn't panic in my side with vcpus=3D1 and can boot to
shell prompt(looks the boot-up is very slow. I have to wait for several min=
utes...)

> From your analysis this doesn't sound framebuffer related - perhaps we
> could drop the linuxfb CC's on these mails going forward?
OK. I removed linuxfb and Jean.

Thanks,
-- Dexuan

--_002_EE124450C0AAF944A40DD71E61F878C995E93ESINEX14MBXC419sou_
Content-Type: application/octet-stream; name="fix_vmbus_open.patch"
Content-Description: fix_vmbus_open.patch
Content-Disposition: attachment; filename="fix_vmbus_open.patch"; size=1058;
	creation-date="Tue, 26 Aug 2014 10:11:42 GMT";
	modification-date="Tue, 26 Aug 2014 10:11:42 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHYvY2hhbm5lbC5jIGIvZHJpdmVycy9odi9jaGFubmVsLmMK
aW5kZXggNTMxYTU5My4uZjUyODNhMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9odi9jaGFubmVsLmMK
KysrIGIvZHJpdmVycy9odi9jaGFubmVsLmMKQEAgLTE2NSw4ICsxNjUsMTAgQEAgaW50IHZtYnVz
X29wZW4oc3RydWN0IHZtYnVzX2NoYW5uZWwgKm5ld2NoYW5uZWwsIHUzMiBzZW5kX3JpbmdidWZm
ZXJfc2l6ZSwKIAlyZXQgPSB2bWJ1c19wb3N0X21zZyhvcGVuX21zZywKIAkJCSAgICAgICBzaXpl
b2Yoc3RydWN0IHZtYnVzX2NoYW5uZWxfb3Blbl9jaGFubmVsKSk7CiAKLQlpZiAocmV0ICE9IDAp
CisJaWYgKHJldCAhPSAwKSB7CisJCWVyciA9IHJldDsKIAkJZ290byBlcnJvcjE7CisJfQogCiAJ
dCA9IHdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmb3Blbl9pbmZvLT53YWl0ZXZlbnQsIDUq
SFopOwogCWlmICh0ID09IDApIHsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHYvY29ubmVjdGlvbi5j
IGIvZHJpdmVycy9odi9jb25uZWN0aW9uLmMKaW5kZXggYWUyMmUzYy4uMTk3ZWEwZSAxMDA2NDQK
LS0tIGEvZHJpdmVycy9odi9jb25uZWN0aW9uLmMKKysrIGIvZHJpdmVycy9odi9jb25uZWN0aW9u
LmMKQEAgLTQyOSwxMSArNDI5LDE0IEBAIGludCB2bWJ1c19wb3N0X21zZyh2b2lkICpidWZmZXIs
IHNpemVfdCBidWZsZW4pCiAJICovCiAJd2hpbGUgKHJldHJpZXMgPCAzKSB7CiAJCXJldCA9ICBo
dl9wb3N0X21lc3NhZ2UoY29ubl9pZCwgMSwgYnVmZmVyLCBidWZsZW4pOwotCQlpZiAocmV0ICE9
IEhWX1NUQVRVU19JTlNVRkZJQ0lFTlRfQlVGRkVSUykKKwkJaWYgKHJldCAhPSBIVl9TVEFUVVNf
SU5TVUZGSUNJRU5UX0JVRkZFUlMpIHsKKwkJCVdBUk4ocmV0LCBLRVJOX0VSUiAicmV0ID0gJWRc
biIsIHJldCk7CiAJCQlyZXR1cm4gcmV0OworCQl9CiAJCXJldHJpZXMrKzsKIAkJbXNsZWVwKDEw
MCk7CiAJfQorCVdBUk4ocmV0LCBLRVJOX0VSUiAicmV0ID0gJWQsIHJldHJpZXM9JWRcbiIsIHJl
dCwgcmV0cmllcyk7CiAJcmV0dXJuIHJldDsKIH0KIAo=

--_002_EE124450C0AAF944A40DD71E61F878C995E93ESINEX14MBXC419sou_--
