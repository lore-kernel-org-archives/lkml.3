Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030876AbaGCJxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:53:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:56736 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964933AbaGCJxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:53:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,594,1400050800"; 
   d="scan'208";a="564638910"
Message-ID: <1404381194.5102.69.camel@smile.fi.intel.com>
Subject: Re: [PATCH 2/6] lib / string_helpers: introduce string_escape_mem()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 03 Jul 2014 12:53:14 +0300
In-Reply-To: <20140702150150.b87702934d47fd481646f6ff@linux-foundation.org>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404307229-19186-3-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140702150150.b87702934d47fd481646f6ff@linux-foundation.org>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 15:01 -0700, Andrew Morton wrote:
> On Wed,  2 Jul 2014 16:20:25 +0300 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > This is almost the opposite function to string_unescape(). Nevertheless it
> > handles \0 and could be used for any byte buffer.
> > 
> > The documentation is supplied together with the function prototype.
> > 
> > The test cases covers most of the scenarios and would be expanded later on.
> > 
> > ...
> >
> > --- a/include/linux/string_helpers.h
> > +++ b/include/linux/string_helpers.h
> > @@ -71,4 +71,87 @@ static inline int string_unescape_any_inplace(char *buf)
> >  	return string_unescape_any(buf, buf, 0);
> >  }
> >  
> > +#define ESCAPE_SPACE		0x01
> > +#define ESCAPE_SPECIAL		0x02
> > +#define ESCAPE_NULL		0x04
> > +#define ESCAPE_OCTAL		0x08
> > +#define ESCAPE_ANY		\
> > +	(ESCAPE_SPACE | ESCAPE_OCTAL | ESCAPE_SPECIAL | ESCAPE_NULL)
> > +#define ESCAPE_NP		0x10
> > +#define ESCAPE_ANY_NP		(ESCAPE_ANY | ESCAPE_NP)
> > +#define ESCAPE_HEX		0x20
> > +
> > +/**
> > + * string_escape_mem - quote characters in the given memory buffer
> 
> It drive me nuts when the kerneldoc is in the .h file.  Who thinks of
> looking there?  I realise that string_unescape() already did that, but
> I'd prefer that we fix string_unescape() rather than imitate it.

No problem, I will do this in separate patch.

> 
> > --- a/lib/string_helpers.c
> > +++ b/lib/string_helpers.c
> 
> This is a lot of code!  Adds nearly a kbyte.  I'm surprised that
> escaping a string is so verbose.
> I wonder if the implementation really needs to be so comprehensive?

I studied several kernel cases and try to cover most of them.

> Would a table-driven approach be more compact?

Do you mean something like ctype set of functions?

I wouldn't think so, we have a lot of variations how we would like to
escape. Currently I have such cases covered in terms of flags I
introduced (not all of them in this series):
 - ESCAPE_OCTAL (with dictionary)
 - ESCAPE_ANY_NP
 - ESCAPE_HEX | ESCAPE_NP
 - ESCAPE_NULL
... not yet in form of patch
 - ESCAPE_SPACE | ESCAPE_SPECIAL (with dictionary)

I can't currently realize how table could cover all of that.

> >  static int __init test_string_helpers_init(void)
> >  {
> >  	unsigned int i;
> > @@ -112,6 +315,16 @@ static int __init test_string_helpers_init(void)
> >  	test_string_unescape("unescape inplace",
> >  			     get_random_int() % (UNESCAPE_ANY + 1), true);
> >  
> > +	/* Without dictionary */
> > +	for (i = 0; i < (ESCAPE_ANY_NP | ESCAPE_HEX) + 1; i++)
> > +		test_string_escape("escape 0", escape0, i, TEST_STRING_2_DICT_0);
> > +
> > +	/* With dictionary */
> > +	for (i = 0; i < (ESCAPE_ANY_NP | ESCAPE_HEX) + 1; i++)
> > +		test_string_escape("escape 1", escape1, i, TEST_STRING_2_DICT_1);
> > +
> > +	test_string_escape_nomem();
> > +
> >  	return -EINVAL;
> >  }
> 
> I wonder why this returns -EINVAL.

The idea of course to not let module be loaded. I saw this return code
in test_kstrtox.c. Would you suggest better approach?


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

