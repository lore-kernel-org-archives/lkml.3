Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaK1QB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:01:58 -0500
Received: from exprod6og127.obsmtp.com ([64.18.1.78]:41037 "EHLO
	exprod6og127.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaK1QBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:01:52 -0500
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 11:01:51 EST
From: Patrick Farrell <paf@cray.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        =?iso-8859-1?Q?Lo=EFc_Pefferkorn?= <loic@loicp.eu>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gdonald@gmail.com" <gdonald@gmail.com>,
        "HPDD-discuss@ml01.01.org" <HPDD-discuss@ml01.01.org>
Subject: RE: [HPDD-discuss] [PATCH] staging: lustre: fix sparse warnings
 related to lock context imbalance
Thread-Topic: [HPDD-discuss] [PATCH] staging: lustre: fix sparse warnings
 related to lock context imbalance
Thread-Index: AQHQCagWB71wZzuU5USMaoAdEy50BJxzx62AgAFrDwCAAQLjgP//9nRc
Date: Fri, 28 Nov 2014 15:45:24 +0000
Message-ID: <DB0C8A206669AC40B1C4E52A8584A6F61496CCB5@CFWEX01.americas.cray.com>
References: <02a457cec587341d0f1665491f6360323694b008.1417017302.git.loic@loicp.eu>
 <20141126205443.GB10615@kroah.com>
 <20141127183410.GA4582@iron>,<20141128100045.GC4860@mwanda>
In-Reply-To: <20141128100045.GC4860@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.234.40]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan,

I disagree about the change suggested here.  In this particular code, 'object_attr' is distinct from 'attr', as in a 'setattr' call on an inode.  'cl_object' is a distinct thing from an inode/file on disk, and specifying it is the objects attr is helpful in understanding there is not a direct relationship to 'attr' in the general filesystem sense.  (cl_object attrs are used in determining actual on disk attributes, but there is not a one-to-one correspondence.)

I am willing to be corrected, but that is my first feeling here.

- Patrick
________________________________________
From: HPDD-discuss [hpdd-discuss-bounces@lists.01.org] on behalf of Dan Carpenter [dan.carpenter@oracle.com]
Sent: Friday, November 28, 2014 4:00 AM
To: Loïc Pefferkorn
Cc: devel@driverdev.osuosl.org; Greg KH; linux-kernel@vger.kernel.org; gdonald@gmail.com; HPDD-discuss@ml01.01.org
Subject: Re: [HPDD-discuss] [PATCH] staging: lustre: fix sparse warnings related to lock context imbalance

On Thu, Nov 27, 2014 at 07:34:10PM +0100, Loïc Pefferkorn wrote:
> 1827         if (valid != 0) {
> 1828             cl_object_attr_lock(obj);
> 1829             cl_object_attr_set(env, obj, attr, valid);
> 1830             cl_object_attr_unlock(obj);
>
> after:
>
> 1827         if (valid != 0) {
> 1828             spin_lock(cl_object_attr_guard(obj));
> 1829             cl_object_attr_set(env, obj, attr, valid);
> 1830             spin_unlock(cl_object_attr_guard(obj));

The word "_object" doesn't add any new information to the name.  If you
remove it then the code is improved.

                spin_lock(cl_attr_guard(obj));
                cl_attr_set(env, obj, attr, valid);
                spin_unlock(cl_attr_guard(obj));


regards,
dan carpenter

_______________________________________________
HPDD-discuss mailing list
HPDD-discuss@lists.01.org
https://lists.01.org/mailman/listinfo/hpdd-discuss
