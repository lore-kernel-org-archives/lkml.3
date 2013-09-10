Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab3IJXRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:17:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32983 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3IJXRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:17:19 -0400
Date: Wed, 11 Sep 2013 02:12:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Brannon <chris@the-brannons.com>
Cc: Raphael S Carvalho <raphael.scarv@gmail.com>, devel@driverdev.osuosl.org,
        Kirk Reiser <kirk@reisers.ca>, speakup@braille.uwo.ca,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 1/1] staging/speakup/kobjects.c: Code improvement.
Message-ID: <20130910231228.GF6329@mwanda>
References: <1378160418-13898-1-git-send-email-raphael.scarv@gmail.com>
 <87fvtefy10.fsf@mushroom.PK5001Z>
 <CACz=WeeE+jxdaxpR_amF60deDcEy8nChYYfY3UA3CNfhmOB8Gw@mail.gmail.com>
 <87y576edm6.fsf@mushroom.PK5001Z>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y576edm6.fsf@mushroom.PK5001Z>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good eye for spotting the memory corruption bug!

This is a bug fix, so the fix should go in a separate patch and not
merged with a code cleanup patch.  Ordinary users can trigger this so
it's a security bug and separating it out is extra important.

The checking in spk_set_num_var() is not sufficient as well.  If we use
E_INC then we can hit an integer overflow bug:

drivers/staging/speakup/varhandlers.c
   198                  if (how == E_SET)
   199                          val = input;
   200                  else
   201                          val = var_data->u.n.value;
   202                  if (how == E_INC)
   203                          val += input;

"input" comes from the user.  This addition can overflow so that input
is a very high number and now "val" is a low enough number.

   204                  else if (how == E_DEC)
   205                          val -= input;
   206                  if (val < var_data->u.n.low || val > var_data->u.n.high)
   207                          return -ERANGE;

"val" is valid, but "input" is not valid.  We use "input" in the caller
function as the index to an array.

   208          }

I guess that's simple enough to fix but why is the caller using "input"
instead of "val"?

regards,
dan carpenter

