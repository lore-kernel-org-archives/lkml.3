Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbaJIV2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:28:20 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49027 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaJIV2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:28:15 -0400
MIME-Version: 1.0
In-Reply-To: <20141009152728.4114ab8c@as>
References: <20141009190406.GA5428@localhost>
	<CAH6sp9Prq3VVbBGEEgaYACWgKf53_93eq93RhAWbmknw0x95QQ@mail.gmail.com>
	<CAH6sp9MrU7HxYya7jBGHehBXUqey-PLzVDkvfjJbrU5v1P1WyQ@mail.gmail.com>
	<FC674684-FA28-47F3-BB5D-6709D2BFF770@osknowledge.org>
	<CAH6sp9NOOuLT8c3X24SXmWUYLOWK38gsFDQhVXuqHKi+JdxUjA@mail.gmail.com>
	<5DD50C84-608E-4A73-B65D-F6369DF7E1D0@osknowledge.org>
	<CAH6sp9Mgyu8xFSM4Morux7YUDToYA2DHJs5hcE-hPVygGWFqpA@mail.gmail.com>
	<20141009152728.4114ab8c@as>
Date: Thu, 9 Oct 2014 23:28:14 +0200
Message-ID: <CAH6sp9MMWWVRTtom8Oo4OSsyQgx5eguDkS+6Usoj7aoZoN-_WQ@mail.gmail.com>
Subject: Re: acpitool - /proc/acpi/wakeup
From: Frans Klaver <fransklaver@gmail.com>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Marc Burkhardt <marc@osknowledge.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 10:27 PM, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
> On Thu, 9 Oct 2014 22:16:11 +0200
> Frans Klaver <fransklaver@gmail.com> wrote:
>
>> On Thu, Oct 9, 2014 at 9:58 PM, Marc Burkhardt <marc@osknowledge.org> wrote:
>> >
>> >
>> >>On Thu, Oct 9, 2014 at 9:42 PM, Marc Burkhardt <marc@osknowledge.org>
>> >>wrote:
>> >>> I upgraded from 3.10 on that machine. 3.12 didn't work for me due to
>> >>a hibernation bug. The rest was left out...  :/
>> >>
>> >>If you still have the 3.12 kernel around, could you test if acpitool
>> >>-e worked there?
>> >
>> > Let me ask you a question: does it make sense to test 3.12 again because you know there's something changed regarding /proc/acpi/... or because it's the kernel I broke up on upgrading?
>>
>> Never mind. It broke after 3.14. I'll bisect.
>>
>
> The below patch fixes it for me. Looks like the line sizes changed
> and some are now exactly the right length to make it loop forever
> reading /proc/acpi/wakeup:
>
>
> --- a/src/acpitool.cpp
> +++ b/src/acpitool.cpp
> @@ -417,7 +417,7 @@ int Do_Fan_Info(int verbose)
>  int Show_WakeUp_Devices(int verbose)
>  {
>      ifstream file_in;
> -    char *filename, str[40];
> +    char *filename, str[80];
>
>      filename = "/proc/acpi/wakeup";
>
> @@ -438,13 +438,13 @@ int Show_WakeUp_Devices(int verbose)
>      }
>      else
>      {
> -       file_in.getline(str, 40);           // first line are just headers //
> +       file_in.getline(str, 80);           // first line are just headers //
>         cout<<"   "<<str<<endl;
>         cout<<"  ---------------------------------------"<<endl;
>          int t = 1;
>         while(!file_in.eof())
>         {
> -           file_in.getline(str, 40);
> +           file_in.getline(str, 80);
>             if (strlen(str)!=0)                     // avoid printing last empty line //
>             {
>                 cout<<"  "<<t<<". "<<str<<endl;

Oh my. Why not use the std::string version of getline?

I doubt we should count this as "breaking userspace"..
