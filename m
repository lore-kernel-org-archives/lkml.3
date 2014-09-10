Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaIJU4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:56:06 -0400
Received: from mail-bn1bon0113.outbound.protection.outlook.com ([157.56.111.113]:31088
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752065AbaIJU4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:56:01 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 16:56:01 EDT
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "dh.herrmann@gmail.com" <dh.herrmann@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "cooloney@gmail.com" <cooloney@gmail.com>,
        "airlied@gmail.com" <airlied@gmail.com>,
        "ajax@redhat.com" <ajax@redhat.com>
Subject: Re: [PATCH RFC 0/4] Linking DRM Connectors to Backlight Devices
Thread-Topic: [PATCH RFC 0/4] Linking DRM Connectors to Backlight Devices
Thread-Index: AQHPzQ+ReaAlSMa+v0aOCKHz6RNakZv61OyA
Date: Wed, 10 Sep 2014 20:40:57 +0000
Message-ID: <1410381657.4117.3.camel@nebula.com>
References: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [208.54.5.157]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019019)(6009001)(24454002)(189002)(377424004)(199003)(50986999)(110136001)(90102001)(106116001)(33646002)(83072002)(4396001)(85852003)(64706001)(85306004)(20776003)(106356001)(99396002)(77982001)(99286002)(103116003)(74502001)(105586002)(79102001)(46102001)(81342001)(36756003)(19580395003)(92566001)(87936001)(77096002)(76482001)(81542001)(76176999)(92726001)(83322001)(101416001)(31966008)(80022001)(97736003)(86362001)(107046002)(66066001)(2351001)(95666004)(74662001)(54356999)(21056001)(19580405001)(2501002)(2656002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR05MB423;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <404849167CC5C84CAD1207B1BDCF3684@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8AKuBM0019233

On Wed, 2014-09-10 at 17:54 +0200, David Herrmann wrote:

>  * User-space currently has a hard-time figuring out which backlight device to
>    use, and which backlight device belongs to which display. So far, most
>    systems only provide backlight-devices for internal displays, so figuring out
>    the connection is easy, but that might change with more capable external
>    connectors.

The parent device of the backlight will be the correct display, if the
kernel has a meaningful way to determine that. We could do a better job
in the ACPI code than we currently do, but (unfortunately) that requires
us to know the ACPI IDs that each GPU vendor uses.

>    If multiple backlights are available, the easiest solution is to simply write
>    to all of them and hope at least one of them works. This obviously fails if
>    the devices interact badly, so it's not really a solution.

There's a pretty well-defined process for that, although it sucks - if
it's an LVDS or eDP display and there's a backlight of type "firmware",
use it. If there's no "firmware" backlight, but there is a "platform"
one, use that. Otherwise look for a "native" backlight that has the
output as a parent. libbacklight does all of this for you. 

>  * User-space needs root privileges to write to sysfs. There are no char-devs
>    that can be used to control access-management to the backlight API, so /sys
>    is the only interface available. So far, udev policy has been "/sys is
>    read-only for non-root" and it's not going to change. char-devs are *THE*
>    standard way to provide non-root user-space APIs, so use them!

Yeah, this is a problem.

> This series tries to solve this problem with a much simpler approach:
> Instead of moving backlights into DRM, we simply link DRM properties to a
> backlight device. That is, the kernel manages a link between a connector and a
> backlight device (or n backlight devices) which can be modified by udev in case
> the kernel got it wrong (we don't want huge board-fixup-tables in the kernel).
> User-space can now use the simpl DRM API to manage backlights, and the kernel
> does not need any special driver code to make it work.

This doesn't really simplify userspace significantly - something's still
going to have to make the same policy decision as we do right now, and
the kernel isn't really the right place to do that. It does have the
benefit of allowing that policy decision to be made at boot time and
then allow that to be consumed by all later userspace, so there is
*some* benefit, but I think the "make unprivileged userspace possible"
argument is much more compelling.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
