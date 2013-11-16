Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3KPLUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 06:20:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:60851 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab3KPLUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 06:20:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,712,1378882800"; 
   d="scan'208";a="434528767"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hammond, John" <john.hammond@intel.com>
Subject: Re: [PATCH 05/40] staging/lustre: validate open handle cookies
Thread-Topic: [PATCH 05/40] staging/lustre: validate open handle cookies
Thread-Index: AQHO4VTD9AspSQR2kkSNfR60drRo45omNYAAgAGDlAA=
Date: Sat, 16 Nov 2013 11:20:37 +0000
Message-ID: <CEAC98F3.818F1%andreas.dilger@intel.com>
In-Reply-To: <20131115041324.GA28088@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.124.174]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6567E68579A5604382A66937240714C6@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/14 9:13 PM, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
wrote:

>On Fri, Nov 15, 2013 at 12:13:07AM +0800, Peng Tao wrote:
>> From: "John L. Hammond" <john.hammond@intel.com>
>> 
>> Add a const void *h_owner member to struct portals_handle. Add a const
>> void *owner parameter to class_handle2object() which must be matched
>> by the h_owner member of the handle in addition to the cookie.
>
>Ick ick ick.
>
>NEVER use a void pointer if you can help it, and for a "handle", never.
>This isn't other operating systems, sorry.  We know what types our
>pointers to structures are, use them, so that the compiler can catch our
>problems, and don't try to cheat by using void *.

The portals_handle is used as a generic type for objects referenced over
the network, like a file handle.  The "owner" parameter is just used as
an extra check that the cookie passed from the client is actually a
valid value for the code in which it is being used (e.g. metadata or
data object).  It isn't actually dereferenced by anything, it is just
like a magic value.

>> Adjust
>> the callers of class_handle2object() accordingly, using NULL as the
>> argument to the owner parameter, except in the case of
>> mdt_handle2mfd() where we add an explicit mdt_export_data parameter
>> which we use as the owner when searching for a MFD. When allocating a
>> new MFD, pass a pointer to the mdt_export_data into mdt_mfd_new() and
>> store it in h_owner. This allows the MDT to validate that the client
>> has not sent the wrong open handle cookie, or sent the right cookie to
>> the wrong MDT.
>
>This changelog entry doesn't even match up with the code below.  ALl
>callers of class_handle2object are passing NULL here, which makes this
>patch pretty pointless, right?

As Tao wrote, this is the patch summary that matches what was committed
in our own tree and in this case mostly describes the changes made on the
server.  Keeping the same commits and comments in both trees makes it
easier to keep the code in sync.

>And that's a _very_ generic global symbol name, please don't do that, it
>needs to be "lustre_*" at the front to even expect it to be acceptable.

There's already something else called a "lustre_handle", so what about
obdclass_handle2object(), since this is in the obdclass module?

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


