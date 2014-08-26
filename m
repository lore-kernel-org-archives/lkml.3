Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbaHZNkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:40:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071AbaHZNkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:40:23 -0400
Message-ID: <53FC8E45.9060401@suse.cz>
Date: Tue, 26 Aug 2014 15:40:21 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "Darrick J. Wong" <darrick.wong@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] builddeb: put the dbg files into the correct directory
References: <20140819054928.GO2808@birch.djwong.org> <20140822135607.GA15255@sepie.suse.cz> <20140822171000.GA10183@birch.djwong.org>
In-Reply-To: <20140822171000.GA10183@birch.djwong.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-22 19:10, Darrick J. Wong wrote:
> On Fri, Aug 22, 2014 at 03:56:07PM +0200, Michal Marek wrote:
>> On Mon, Aug 18, 2014 at 10:49:28PM -0700, Darrick J. Wong wrote:
>>> Since the conversion of objtree to use relative pathnames (commit
>>> 7e1c04779e, "kbuild: Use relative path for $(objtree)"), the debug
>>> info files have been ending up in /debian/dbgtmp/ in the regular
>>> linux-image package instead of the debug files package.  Fix up the
>>> paths so that the debug files end up in the -dbg package.
>>>
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> ---
>>>  scripts/package/builddeb |    7 ++++---
>>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
>>> index 5707466..0456322 100644
>>> --- a/scripts/package/builddeb
>>> +++ b/scripts/package/builddeb
>>> @@ -153,15 +153,16 @@ if grep -q '^CONFIG_MODULES=y' $KCONFIG_CONFIG ; then
>>>  	fi
>>>  	if [ -n "$BUILD_DEBUG" ] ; then
>>>  		(
>>> +			old_dir="$(pwd)"
>>>  			cd $tmpdir
>>
>> Can you try the patch below? I'd rather get rid of the directory change,
>> if possible.
>>
>> Michal
>>
>> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
>> index 35d5a58..dcfdbda 100755
>> --- a/scripts/package/builddeb
>> +++ b/scripts/package/builddeb
>> @@ -152,18 +152,16 @@ if grep -q '^CONFIG_MODULES=y' $KCONFIG_CONFIG ; then
>>  		rmdir "$tmpdir/lib/modules/$version"
>>  	fi
>>  	if [ -n "$BUILD_DEBUG" ] ; then
>> -		(
>> -			cd $tmpdir
>> -			for module in $(find lib/modules/ -name *.ko); do
>> -				mkdir -p $(dirname $dbg_dir/usr/lib/debug/$module)
>> -				# only keep debug symbols in the debug file
>> -				$OBJCOPY --only-keep-debug $module $dbg_dir/usr/lib/debug/$module
>> -				# strip original module from debug symbols
>> -				$OBJCOPY --strip-debug $module
>> -				# then add a link to those
>> -				$OBJCOPY --add-gnu-debuglink=$dbg_dir/usr/lib/debug/$module $module
>> -			done
>> -		)
>> +		for module in $(find $tmpdir/lib/modules/ -name *.ko -printf '%P\n'); do
>> +			module=lib/modules/$module
>> +			mkdir -p $(dirname $dbg_dir/usr/lib/debug/$module)
>> +			# only keep debug symbols in the debug file
>> +			$OBJCOPY --only-keep-debug $tmpdir/$module $dbg_dir/usr/lib/debug/$module
>> +			# strip original module from debug symbols
>> +			$OBJCOPY --strip-debug $tmpdir/$module
>> +			# then add a link to those
>> +			$OBJCOPY --add-gnu-debuglink=$dbg_dir/usr/lib/debug/$module $module
> 
> This should read:
> 
> $OBJCOPY --add-gnu-debuglink=$dbg_dir/usr/lib/debug/$module $tmpdir/$module
> 
> (The last argument needs "$tmpdir/".)

Oops, you are right.


> but otherwise it's ok, so you can add:
> Tested-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!

Michal

