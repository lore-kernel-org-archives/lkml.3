Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaAFR0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:26:42 -0500
Received: from exchange10.columbia.tresys.com ([216.30.191.171]:17073 "EHLO
	exchange10.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979AbaAFR0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:26:41 -0500
From: William Roberts <WRoberts@tresys.com>
To: Mateusz Guzik <mguzik@redhat.com>,
        William Roberts <bill.c.roberts@gmail.com>
CC: "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rgb@redhat.com" <rgb@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>
Subject: RE: [RFC][PATCH 3/3] audit: Audit proc cmdline value
Thread-Topic: [RFC][PATCH 3/3] audit: Audit proc cmdline value
Thread-Index: AQHPCvRJxM9wEjZWtUqVgWBPL+R065p4QeAA//+wiBA=
Date: Mon, 6 Jan 2014 17:26:15 +0000
Message-ID: <A8856C6323EFE0459533E910625AB9303DC9C7@Exchange10.columbia.tresys.com>
References: <1389022230-24664-1-git-send-email-wroberts@tresys.com>
 <1389022230-24664-3-git-send-email-wroberts@tresys.com>
 <20140106170855.GA1828@mguzik.redhat.com>
In-Reply-To: <20140106170855.GA1828@mguzik.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.143.134]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s06HQojE008370



-----Original Message-----
From: Mateusz Guzik [mailto:mguzik@redhat.com] 
Sent: Monday, January 06, 2014 9:09 AM
To: William Roberts
Cc: linux-audit@redhat.com; linux-mm@kvack.org; linux-kernel@vger.kernel.org; rgb@redhat.com; viro@zeniv.linux.org.uk; akpm@linux-foundation.org; sds@tycho.nsa.gov; William Roberts
Subject: Re: [RFC][PATCH 3/3] audit: Audit proc cmdline value

I can't comment on the concept, but have one nit.

On Mon, Jan 06, 2014 at 07:30:30AM -0800, William Roberts wrote:
> +static void audit_log_cmdline(struct audit_buffer *ab, struct task_struct *tsk,
> +			 struct audit_context *context)
> +{
> +	int res;
> +	char *buf;
> +	char *msg = "(null)";
> +	audit_log_format(ab, " cmdline=");
> +
> +	/* Not  cached */
> +	if (!context->cmdline) {
> +		buf = kmalloc(PATH_MAX, GFP_KERNEL);
> +		if (!buf)
> +			goto out;
> +		res = get_cmdline(tsk, buf, PATH_MAX);
> +		/* Ensure NULL terminated */
> +		if (buf[res-1] != '\0')
> +			buf[res-1] = '\0';

This accesses memory below the buffer if get_cmdline returned 0, which I believe will be the case when someone jokingly unmaps the area (all maybe when it is swapped out but can't be swapped in due to I/O errors).
[William Roberts] 
Sorry for the weird inline posting (Thanks MS Outlook of doom). Anyways, this isnâ€™t a nit. This is a major issue that should be dealt with. Thanks.

Also since you are just putting 0 in there anyway I don't see much point in testing for it.

> +		context->cmdline = buf;
> +	}
> +	msg = context->cmdline;
> +out:
> +	audit_log_untrustedstring(ab, msg);
> +}
> +



--
Mateusz Guzik
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
